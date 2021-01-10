//
//  LocationViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var currentLocationButtonView: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchTextField()
        prepareCurrentLocationButtonView()
    }
    
    func prepareSearchTextField() {
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

    func prepareCurrentLocationButtonView() {
        currentLocationButtonView.layer.masksToBounds = false
        currentLocationButtonView.layer.cornerRadius = 8
    }

}
