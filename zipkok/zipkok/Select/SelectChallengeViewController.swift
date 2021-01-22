//
//  SelectChallengeViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/20.
//

import UIKit

class SelectChallengeViewController: UIViewController {

    @IBOutlet private weak var selectCollectionView: UICollectionView!
    
    private let selectChallengeViewModel = SelectChallengeViewModel()
    private var challenges: [Challenge] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSelectCollectionView()
        prepareNavigationTitle()
        bind()
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
            print("준비중")
            // for test
            let startDate = Date()
            
            guard let endDate = Calendar.current.date(byAdding: .second, value: 30, to: startDate) else {
                return
                
            }
            guard let timerSettingVc = UIStoryboard(name: "TimerSetting", bundle: nil).instantiateInitialViewController() as? TimerSettingViewController else { return }
            
            timerSettingVc.startDate = startDate
            timerSettingVc.endDate = endDate
            
            navigationController?.pushViewController(timerSettingVc, animated: true)
            return
        }
        
        let challenge = challenges[indexPath.item]
        let dayNumber = challenge.dayNumber
        let startDate = Date()
        
        guard let endDate = Calendar.current.date(byAdding: .day, value: dayNumber, to: startDate) else {
            return
            
        }
        guard let timerSettingVc = UIStoryboard(name: "TimerSetting", bundle: nil).instantiateInitialViewController() as? TimerSettingViewController else { return }
        
        timerSettingVc.startDate = startDate
        timerSettingVc.endDate = endDate
        
        navigationController?.pushViewController(timerSettingVc, animated: true)
    }
}

extension SelectChallengeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width - (24 * 2)
        let height: CGFloat = 155
        
        return CGSize(width: width, height: height)
    }
}
