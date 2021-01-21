//
//  SettingViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/11.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet private weak var settingTableView: UITableView!
    
    private let settingViewModel = SettingViewModel()
    
    private var settingNavigaterTitles: [String] = [
        "푸쉬알림", "인증 달력 보기", "타임라인 전체보기", "도움말"
    ]
    
    private var userInfo: UserInfoResult?
    
    lazy var resetButtonGesture: UITapGestureRecognizer = {
        let tapGesuture = UITapGestureRecognizer(target: self, action: #selector(resetButtonTapped))
        return tapGesuture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationTitle()
        prepareSettingTableView()
        bind()
        settingViewModel.requestUserInfo()
    }
    
    private func bind() {
        settingViewModel.userInfo.bind { [weak self] userInfo in
            guard let self = self else { return }
            self.userInfo = userInfo
            self.settingTableView.reloadData()
        }
    }
    
    private func prepareSettingTableView() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 1)) // remove extra, last separator line
        settingTableView.register(UINib(nibName: "SettingProfileCell", bundle: nil), forCellReuseIdentifier: "SettingProfileCell")
        settingTableView.register(UINib(nibName: "SettingNavigatorCell", bundle: nil), forCellReuseIdentifier: "SettingNavigatorCell")
    }

    private func prepareNavigationTitle() {
        navigationItem.title = "마이페이지"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NotoSansCJKkr-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)]
    }
    
    @objc func resetButtonTapped() {
        guard let locationVc = UIStoryboard(name: "Location", bundle: nil).instantiateInitialViewController() as? LocationViewController else { fatalError() }
        
        locationVc.locationPatchCompletionHandler = { [weak self] location in
            guard let self = self else { return }
            self.userInfo = self.userInfo?.changeAddressName(by: location.name)
            self.settingTableView.reloadData()
        }
        locationVc.locationRequestType = .patch
        navigationController?.pushViewController(locationVc, animated: true)
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : settingNavigaterTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let settingProfileCell = tableView.dequeueReusableCell(withIdentifier: "SettingProfileCell", for: indexPath) as? SettingProfileCell else { fatalError() }
            
            if let userInfo = userInfo {
                settingProfileCell.prepare(by: userInfo)
            }
            
            settingProfileCell.resetButtonLabel.addGestureRecognizer(resetButtonGesture)
            settingProfileCell.resetButtonLabel.isUserInteractionEnabled = true
            return settingProfileCell
        case 1:
            guard let settingNavigatorCell = tableView.dequeueReusableCell(withIdentifier: "SettingNavigatorCell", for: indexPath) as? SettingNavigatorCell else { fatalError() }
            if indexPath.row == 0 {
                settingNavigatorCell.swtichButton.isSelected = userInfo?.isPushStatusEnable ?? false
                settingNavigatorCell.prepareSwitchButton()
            }
            settingNavigatorCell.titleLabel.text = settingNavigaterTitles[indexPath.row]
            return settingNavigatorCell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 8))
            separatorView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
            return separatorView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 8 : CGFloat.zero
    }
}

extension SettingViewController: UITableViewDelegate {
}
