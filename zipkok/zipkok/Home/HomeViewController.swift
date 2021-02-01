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
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    private let keyChainManager = KeyChainManager()
    private var isReceivedCurrentLocation: Bool = false
    private var isStartButtonTapped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareStartButtonView()
        prepareIconTextLabel()
        prepareNavigationBarItems()
    }
    
    private func prepareIconTextLabel() {
        iconTextLabel.transform = CGAffineTransform(rotationAngle: -(.pi/8))
    }
    
    private func prepareNavigationBarItems() {
        let profileBarButtonItem = UIBarButtonItem(image: UIImage(named: "그룹 114")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        profileBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        let shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "그룹 116")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(shareBarButtonItemTapped))
        shareBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        let settingBarButtonItem = UIBarButtonItem(image: UIImage(named: "그룹 113")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(settingBarButtonItemTapped))
        settingBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        
        navigationItem.leftBarButtonItem = profileBarButtonItem
        navigationItem.rightBarButtonItems = [settingBarButtonItem, shareBarButtonItem]
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
    
    private func alertLocationAuthView(message: String) {
        guard let navVc = navigationController else { return }

        let customAlertView = CustomAlertView.loadViewFromNib()
        customAlertView.translatesAutoresizingMaskIntoConstraints = false
        customAlertView.contentLabel.text = message
        navVc.view.addSubview(customAlertView)
        
        NSLayoutConstraint.activate([
            customAlertView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customAlertView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customAlertView.topAnchor.constraint(equalTo: view.topAnchor),
            customAlertView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func settingBarButtonItemTapped(_ sender: UIBarButtonItem) {
        guard let settingVc = SettingViewController.storyboardInstance() else {
            fatalError()
        }
        
        navigationController?.pushViewController(settingVc, animated: true)
    }
    
    @objc func shareBarButtonItemTapped() {
        KakaoApi.shared.sendRecommendTemplate()
    }
    
    @objc private func startButtonViewTapped() {
        guard isStartButtonTapped == false else { return }
        
        isStartButtonTapped = true
        view.makeToastActivity(.center)
        locationManager.requestWhenInUseAuthorization()

        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            isStartButtonTapped = false
            view.hideToastActivity()
            alertLocationAuthView(message: """
                                집콕 챌린지를 시작하기 위해서는 사용자의 위치 권한이 필요합니다. \n
                                설정 > 개인 정보 보호 > 위치 서비스에서 집콕 앱을 활성화해주세요.
                                """)
        default:
            isReceivedCurrentLocation = false
            locationManager.startUpdatingLocation()
        }

    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let jwtToken = keyChainManager.jwtToken else {
            print("---> Access Token can't loaded")
            return
        }
        if let coor = manager.location?.coordinate, !isReceivedCurrentLocation {
            let latitude = coor.latitude
            let longitude = coor.longitude
            
            isReceivedCurrentLocation = true
            locationManager.stopUpdatingLocation()
            locationManager.stopMonitoringSignificantLocationChanges()
            
            ZipkokApi.shared.userLocation(jwt: jwtToken, latitude: latitude, longitude: longitude) { userLocationResponse in
                self.view.hideToastActivity()
                self.isStartButtonTapped = false
                
                if userLocationResponse.isSuccess {
                    guard let selectChallengeVc = SelectChallengeViewController.storyboardInstance() else { return }
            
                    self.navigationController?.pushViewController(selectChallengeVc, animated: true)
                } else {
                    self.alertLocationAuthView(message: "집콕은 현재 집으로 등록된 장소에서만\n가능합니다. \n\n집으로 이동하여 진행하거나, 마이페이지에서 우리집설정을 변경해주세요.")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
}
