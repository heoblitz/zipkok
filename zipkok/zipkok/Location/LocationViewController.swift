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
    
    @IBOutlet private weak var recentLocationTableView: UITableView!
    @IBOutlet private weak var recentLocationTableViewHeight: NSLayoutConstraint!
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
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
    private let recentLocationViewModel = RecentLocationViewModel()
    private var recentLocations: [RecentLocation] = [] {
        didSet {
            if recentLocations.count == 0 {
                recentLocationTableView.isHidden = true
            } else {
                recentLocationTableView.isHidden = false
            }
        }
    }
    
    private var isReceivedCurrentLocation: Bool = false
    
    var locationRequestType: LocationRequestType = .register
    var locationPatchCompletionHandler: ((LocationInfo) -> ())?
    var locationInfo: LocationInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationTitle()
        prepareSearchTextField()
        prepareCurrentLocationButtonView()
        prepareSubmitButton()
        prepareRecentLocationTableView()
        
        bind()
        
        if let jwtToken = keyChainManager.jwtToken {
            recentLocationViewModel.requestRecentLocations(jwt: jwtToken)
        }
    }
    
    static func storyboardInstance() -> LocationViewController? {
        let storyboard = UIStoryboard(name: LocationViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func bind() {
        recentLocationViewModel.locations.bind { [weak self] recentLocations in
            guard let self = self else { return }
            self.recentLocations = recentLocations
            self.recentLocationTableViewHeight.constant = CGFloat(60 + (79 * recentLocations.count))
            self.recentLocationTableView.reloadData()
        }
    }
    
    private func prepareRecentLocationTableView() {
        recentLocationTableView.dataSource = self
        recentLocationTableView.delegate = self
        recentLocationTableView.register(UINib(nibName: "RecentLocationCell", bundle: nil), forCellReuseIdentifier: "RecentLocationCell")
        recentLocationTableView.register(UINib(nibName: "RecentLocationHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "RecentLocationHeaderView")
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
        tapGusture.cancelsTouchesInView = false
        currentLocationButtonView.isUserInteractionEnabled = true
        currentLocationButtonView.addGestureRecognizer(tapGusture)
        currentLocationButtonView.layer.masksToBounds = false
        currentLocationButtonView.layer.cornerRadius = 8
    }
    
    private func prepareNavigationTitle() {
        navigationItem.title = "우리집설정"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NotoSansCJKkr-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)]
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
    
    private func register() {
        guard let locationInfo = locationInfo, let accessToken = keyChainManager.accessToken else {
            print("---> register location, accessToken can't loaded")
            return
        }
        
        activityIndicatorView.startAnimating()
        
        DispatchQueue.global().async {
            KakaoApi.shared.getUserInformation(token: accessToken) { userInformation in
                ZipkokApi.shared.register(location: locationInfo, user: userInformation) { registerResponse in
                    
                    self.keyChainManager.jwtToken = registerResponse.result?.jwt
                    self.keyChainManager.userId = registerResponse.result?.userIdx
                    
                    if registerResponse.isSuccess, registerResponse.code == 1012 {
                        DispatchQueue.main.async {
                            self.activityIndicatorView.stopAnimating()
                            guard let homeNavVc = HomeNavigationViewController.storyboardInstance() else { return }
                            
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
    
    private func patchUserInfo() {
        guard let locationInfo = locationInfo, let jwt = keyChainManager.jwtToken, let userId = keyChainManager.userId else {
            print("---> patchUserInfo locationInfo, jwt, userId can't loaded")
            return
        }
        
        ZipkokApi.shared.patchUserInfo(jwt: jwt, id: userId, location: locationInfo) {  patchUserInfoResponse in
            if patchUserInfoResponse.isSuccess {
                self.locationPatchCompletionHandler?(locationInfo)
                self.navigationController?.popViewController(animated: true)
            } else { // 예외 처리
            }
        }
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
            alertLocationAuthView()
        default:
            // locationManager.requestLocation()
            isReceivedCurrentLocation = false
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func submitButtonTapped() {
        if searchTextField.text?.isEmpty ?? true {
            // 비어있으니 예외처리
            print("비어있으니 예외처리")
            return
        }
        
        switch locationRequestType {
        case .register:
            register()
        case .patch:
            patchUserInfo()
        }
    }
}

extension LocationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let locationWebVc = LocationWebViewController.storyboardInstance() else {
            fatalError()
        }
        locationWebVc.completionHandler = setTextFieldFromLocationWeb
        
        viewTapped()
        navigationController?.pushViewController(locationWebVc, animated: true)
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate, !isReceivedCurrentLocation {
            let latitude = coor.latitude
            let longitude = coor.longitude
            
            isReceivedCurrentLocation = true
            locationManager.stopUpdatingLocation()
            locationManager.stopMonitoringSignificantLocationChanges()
            
            GeoCodingApi.shared.requestRegioncode(by: (longitude, latitude), completionHandler: { [weak self] addressName in
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

extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recentLocationCell = tableView.dequeueReusableCell(withIdentifier: "RecentLocationCell", for: indexPath) as? RecentLocationCell else {
            fatalError()
        }
        let location = recentLocations[indexPath.item]
        recentLocationCell.update(by: location)
        
        return recentLocationCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RecentLocationHeaderView") else {
            fatalError()
        }
        headerView.contentView.backgroundColor = .white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        separatorView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        return separatorView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = recentLocations[indexPath.item]
        let parcelAddress = location.parcelAddressing
        
        GeoCodingApi.shared.requestCoord(by: location.parcelAddressing) { [weak self] (latitude, longitude) in
            guard let self = self else { return }
            let locationInfo = LocationInfo(latitude: latitude, longitude: longitude, name: parcelAddress)
            
            self.locationInfo = locationInfo
            self.searchTextField.text = location.streetAddressing
        }
    }
}
