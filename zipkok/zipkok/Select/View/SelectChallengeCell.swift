//
//  SelectChallengeCell.swift
//  zipkok
//
//  Created by won heo on 2021/01/20.
//

import UIKit

final class SelectChallengeCell: UICollectionViewCell {

    @IBOutlet weak var difficultyIconStackView: UIStackView!
    @IBOutlet weak var dayNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.masksToBounds = false
        layer.cornerRadius = 15
        layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.16
        layer.shadowRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func prepare(by challenge: Challenge) {
        prepareDifficultyIcon(count: challenge.difficulty)
        dayNumberLabel.text = challenge.koreanDayFormat
    }
    
    private func makeDifficultyIcon() -> UIImageView {
        let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        icon.image = UIImage(named: "그룹 1456") ?? UIImage()
        return icon
    }
    
    private func prepareDifficultyIcon(count: Int) {
        for view in difficultyIconStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for _ in 0..<count {
            difficultyIconStackView.addArrangedSubview(makeDifficultyIcon())
        }
    }
}
