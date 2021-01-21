//
//  HomeViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/11.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet private weak var startButtonView: UIView!
    @IBOutlet private weak var iconTextLabel: UILabel!
    
    @IBOutlet private weak var profileBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var settingBarButtonItem: UIBarButtonItem!
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    private let keyChainManager = KeyChainManager()
    private var isReceivedCurrentLocation: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareStartButtonView()
        prepareIconTextLabel()
        prepareBarButtonItems()
    }
    
    private func prepareIconTextLabel() {
        iconTextLabel.transform = CGAffineTransform(rotationAngle: -(.pi/8))
    }
    
    private func prepareStartButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startButtonViewTapped))
        startButtonView.isUserInteractionEnabled = true
        startButtonView.addGestureRecognizer(tapGesture)
        
        startButtonView.layer.masksToBounds = false
        startButtonView.layer.cornerRadius = 8
        startButtonView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        startButtonView.layer.shadowOffset = CGSize(width: 0, height: 12)
        startButtonView.layer.shadowOpacity = 0.25
        startButtonView.layer.shadowRadius = 14
    }
    
    private func alertLocationAuthView() {
        guard let navVc = navigationController else { return }

        let customAlertView = CustomAlertView.loadViewFromNib()
        customAlertView.translatesAutoresizingMaskIntoConstraints = false
        customAlertView.contentLabel.text = """
                                집콕 챌린지를 시작하기 위해서는 사용자의 위치 권한이 필요합니다. \n
                                설정 > 개인 정보 보호 > 위치 서비스에서 집콕 앱을 활성화해주세요.
                                """
        navVc.view.addSubview(customAlertView)
        
        NSLayoutConstraint.activate([
            customAlertView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customAlertView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customAlertView.topAnchor.constraint(equalTo: view.topAnchor),
            customAlertView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func prepareBarButtonItems() {
        profileBarButtonItem.image = UIImage(named: "그룹 114")?.withRenderingMode(.alwaysOriginal)
        shareBarButtonItem.image = UIImage(named: "그룹 116")?.withRenderingMode(.alwaysOriginal)
        settingBarButtonItem.image = UIImage(named: "그룹 113")?.withRenderingMode(.alwaysOriginal)
    }
    
    @IBAction func settingBarButtonItemTapped(_ sender: UIBarButtonItem) {
        guard let settingVc = UIStoryboard(name: "Setting", bundle: nil).instantiateInitialViewController() as? SettingViewController else {
            fatalError()
        }
        
        navigationController?.pushViewController(settingVc, animated: true)
    }
    
    @objc private func startButtonViewTapped() {
        locationManager.requestWhenInUseAuthorization()

        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            print("권한 없음")
            alertLocationAuthView()
        default:
            isReceivedCurrentLocation = false
            locationManager.startUpdatingLocation()
        }
//        guard let selectChallengeVc = UIStoryboard(name: "SelectChallenge", bundle: nil).instantiateInitialViewController() as? SelectChallengeViewController else { fatalError() }
//
//        navigationController?.pushViewController(selectChallengeVc, animated: true)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate, !isReceivedCurrentLocation {
            let latitude = coor.latitude
            let longitude = coor.longitude
            
            isReceivedCurrentLocation = true
            locationManager.stopUpdatingLocation()
            locationManager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
}
