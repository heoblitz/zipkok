//
//  LocationViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var currentLocationButtonView: UIView!
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationTitle()
        prepareViewTapGesture()
        prepareSearchTextField()
        prepareCurrentLocationButtonView()
    }
    
    private func prepareSearchTextField() {
        searchTextField.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: searchTextField.frame.height))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요", attributes: [
            .foregroundColor: UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1),
            .font: UIFont(name: "NotoSansCJKkr-Regular", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        ])
        
        searchTextField.layer.masksToBounds = false
        searchTextField.layer.cornerRadius = 8
    }

    private func prepareCurrentLocationButtonView() {
        let tapGusture = UITapGestureRecognizer(target: self, action: #selector(currentLocationButtonViewTapped))
        currentLocationButtonView.isUserInteractionEnabled = true
        currentLocationButtonView.addGestureRecognizer(tapGusture)
        currentLocationButtonView.layer.masksToBounds = false
        currentLocationButtonView.layer.cornerRadius = 8
    }
    
    private func prepareViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    private func prepareNavigationTitle() {
        navigationItem.title = "우리집설정"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NotoSansCJKkr-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)]
    }
    
    private func alertMessage(for message: String) {
        let alert = UIAlertController(title: "test", message: message, preferredStyle: .alert)
        let admit = UIAlertAction(title: "확인", style: .default, handler: { _ in
            // self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(admit)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func viewTapped() {
        searchTextField.resignFirstResponder()
    }

    @objc private func currentLocationButtonViewTapped() {
        locationManager.requestWhenInUseAuthorization()
        
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            print("no permisson")
            // 위치 요청 alert 뷰 올리기
        default:
            locationManager.requestLocation()
        }
    }
}

extension LocationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let locationWebVc = UIStoryboard(name: "LocationWeb", bundle: nil).instantiateInitialViewController() as? LocationWebViewController else {
            fatalError()
        }
        
        viewTapped()
        navigationController?.pushViewController(locationWebVc, animated: true)
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate{
            let latitude = coor.latitude
            let longitude = coor.longitude
            
            GeoCodingApi.shared.requestRegioncode(by: (longitude, latitude), completeHander: {  [weak self] addressName in
                guard let self = self else { return }
                
                OperationQueue.main.addOperation {
                    self.alertMessage(for: "name: \(addressName)\n latitude: \(latitude)\n longitude: \(longitude)")
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }
}
