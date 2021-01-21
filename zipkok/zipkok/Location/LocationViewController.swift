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
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var submitButton: UIButton!
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    lazy var setTextFieldFromLocationWeb: ((LocationInfo) -> Void) = { [weak self] info in
        guard let self = self else { return }
        OperationQueue.main.addOperation {
            self.locationInfo = info
            self.searchTextField.text = info.name
        }
    }
    
    private let keyChainManager = KeyChainManager()
    
    var locationInfo: LocationInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationTitle()
        prepareViewTapGesture()
        prepareSearchTextField()
        prepareCurrentLocationButtonView()
        prepareSubmitButton()
    }
    
    private func prepareSubmitButton() {
        submitButton.layer.masksToBounds = false
        submitButton.layer.cornerRadius = 8
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = CGColor(red: 34/255, green: 145/255, blue: 255/255, alpha: 1)
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
        activityIndicatorView.startAnimating()
        
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            print("no permisson")
            // 위치 요청 alert 뷰 올리기
            activityIndicatorView.stopAnimating()
        default:
            locationManager.requestLocation()
        }
    }
    
    @IBAction func submitButtonTapped() {
        if searchTextField.text?.isEmpty ?? true {
            // 비어있으니 예외처리
            print("비어있으니 예외처리")
            return
        }
        
        guard let locationInfo = locationInfo, let accessToken = keyChainManager.accessToken else {
            print("값을 못불러움")
            return
        }
        
        activityIndicatorView.startAnimating()
        
        DispatchQueue.global().async {
            KakaoApi.shared.getUserInformation(token: accessToken) { userInformation in
                ZipkokApi.shared.register(location: locationInfo, user: userInformation) { registerResponse in
                    
                    self.keyChainManager.jwtToken = registerResponse.result?.jwt
                    self.keyChainManager.userId = registerResponse.result?.userId
                    
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        guard let homeNavVc = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as? HomeNavigationViewController else { return }
                        
                        guard let window = UIApplication.shared.windows.first else { return }
                        window.rootViewController = homeNavVc
                        
                        let options: UIView.AnimationOptions = .transitionCrossDissolve
                        let duration: TimeInterval = 0.5
                        
                        UIView.transition(with: window, duration: duration, options: options, animations: {}) { completed in
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}

extension LocationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let locationWebVc = UIStoryboard(name: "LocationWeb", bundle: nil).instantiateInitialViewController() as? LocationWebViewController else {
            fatalError()
        }
        locationWebVc.completionHandler = setTextFieldFromLocationWeb
        
        viewTapped()
        navigationController?.pushViewController(locationWebVc, animated: true)
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate{
            let latitude = coor.latitude
            let longitude = coor.longitude
            
            GeoCodingApi.shared.requestRegioncode(by: (longitude, latitude), completionHandler: {  [weak self] addressName in
                guard let self = self else { return }
                
                OperationQueue.main.addOperation {
                    self.activityIndicatorView.stopAnimating()
                    self.searchTextField.text = addressName
                    self.locationInfo = LocationInfo(latitude: "\(latitude)", longitude: "\(longitude)", name: addressName)
                    print(addressName, latitude, longitude)
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }
}
