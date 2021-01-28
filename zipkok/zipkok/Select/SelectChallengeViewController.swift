//
//  SelectChallengeViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/20.
//

import UIKit
import Toast_Swift

class SelectChallengeViewController: UIViewController {

    @IBOutlet private weak var selectCollectionView: UICollectionView!
    
    private lazy var confirmAlertView: ChallengeConfirmAlertView = {
        let confirmAlertView = ChallengeConfirmAlertView.loadViewFromNib()
        confirmAlertView.translatesAutoresizingMaskIntoConstraints = false
        
        let startTap = UITapGestureRecognizer(target: self, action: #selector(confirmAlertStartButtonTapped))
        confirmAlertView.startButtonView.addGestureRecognizer(startTap)
        confirmAlertView.startButtonView.isUserInteractionEnabled = true
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(confirmAlertCancelButtonTapped))
        confirmAlertView.cancelButtonView.addGestureRecognizer(cancelTap)
        confirmAlertView.cancelButtonView.isUserInteractionEnabled = true
        
        return confirmAlertView
    }()
    
    private let selectChallengeViewModel = SelectChallengeViewModel()
    private var challenges: [Challenge] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSelectCollectionView()
        prepareNavigationTitle()
        bind()
    }
    
    static func storyboardInstance() -> SelectChallengeViewController? {
        let storyboard = UIStoryboard(name: SelectChallengeViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func bind() {
        selectChallengeViewModel.challenges.bind { [weak self] challenges in
            self?.challenges = challenges
            self?.selectCollectionView.reloadData()
        }
    }
    
    private func prepareSelectCollectionView() {
        selectCollectionView.delegate = self
        selectCollectionView.dataSource = self
        selectCollectionView.register(UINib(nibName: "SelectChallengeCell", bundle: nil), forCellWithReuseIdentifier: "SelectChallengeCell")
        selectCollectionView.register(UINib(nibName: "CustomSelectChallengeCell", bundle: nil), forCellWithReuseIdentifier: "CustomSelectChallengeCell")
    }
    
    private func prepareNavigationTitle() {
        navigationItem.title = "챌린지 선택하기"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NotoSansCJKkr-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)]
    }
    
    private func alertConfirmView(by dayNumber: Int) {
        confirmAlertView.dayNumberLabel.text = "\(dayNumber)"
        view.addSubview(confirmAlertView)
        
        NSLayoutConstraint.activate([
            confirmAlertView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmAlertView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmAlertView.topAnchor.constraint(equalTo: view.topAnchor),
            confirmAlertView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func confirmAlertCancelButtonTapped() {
        confirmAlertView.removeFromSuperview()
    }
    
    @objc func confirmAlertStartButtonTapped() {
        guard let timerSettingVc = UIStoryboard(name: "TimerSetting", bundle: nil).instantiateInitialViewController() as? TimerSettingViewController else { return }
        
        guard let dayNumberString = confirmAlertView.dayNumberLabel.text, let dayNumber = Int(dayNumberString) else { return }
        
        confirmAlertView.removeFromSuperview()
        
        timerSettingVc.dayNumber = dayNumber
        navigationController?.pushViewController(timerSettingVc, animated: true)
    }
}

extension SelectChallengeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challenges.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case challenges.count:
            guard let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomSelectChallengeCell", for: indexPath) as? CustomSelectChallengeCell else { fatalError() }
            return customCell
        default:
            guard let selectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectChallengeCell", for: indexPath) as? SelectChallengeCell else { fatalError() }
            let challenge = challenges[indexPath.item]
            selectCell.prepare(by: challenge)
            return selectCell
        }
    }
}

extension SelectChallengeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == challenges.count {
            view.makeToast("준비중인 기능입니다.")
            return
        }
        let challenge = challenges[indexPath.item]
        let dayNumber = challenge.dayNumber
        
        alertConfirmView(by: dayNumber)
    }
}

extension SelectChallengeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width - (24 * 2)
        let height: CGFloat = 155
        
        return CGSize(width: width, height: height)
    }
}
