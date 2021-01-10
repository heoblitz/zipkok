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
    
    @objc private func viewTapped() {
        searchTextField.resignFirstResponder()
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
