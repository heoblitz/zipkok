//
//  ViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/09.
//

import UIKit
import SwiftKeychainWrapper
import AuthenticationServices

class TestViewController: UIViewController {
    
    @IBOutlet private weak var signInView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addButton()
    }

    static func storyboardInstance() -> TestViewController? {
        let storyboard = UIStoryboard(name: TestViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    @IBAction func requestCoordButtonTapped() {
        GeoCodingApi.shared.requestCoord(by: "석계로 49") { x, y in
            print(x, y)
        }
    }
    
    @IBAction func requestRegioncode() {
//        GeoCodingApi.shared.requestRegioncode(by: (127.06253874566, 37.6172252018111), completionHandler: { addressName in
//            print(addressName)
//        })
    }
    
    @IBAction func kakaoLogin() {
        let customView = CustomAlertView.loadViewFromNib()
        customView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customView)

        NSLayoutConstraint.activate([
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customView.topAnchor.constraint(equalTo: view.topAnchor),
            customView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])        
    }
    
    @IBAction func SelectChallengeViewController() {
        guard let vc = UIStoryboard(name: "SelectChallenge", bundle: nil).instantiateInitialViewController() as? SelectChallengeViewController else { fatalError() }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func addButton() {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(self, action: #selector(handleAppleSignInButton), for: .touchUpInside)
        signInView.addSubview(button)
    }
    
    @objc func handleAppleSignInButton() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self as ASAuthorizationControllerDelegate
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
}

extension TestViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let identityToken = String(data: credential.identityToken!, encoding: .utf8)!
            let authorizationCode = String(data: credential.authorizationCode!, encoding: .utf8)!

            print("identityToken", identityToken)
            print("authorizationCode", authorizationCode)
        }
    }
}
