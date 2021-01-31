//
//  LoginViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import UIKit
import AuthenticationServices
import KakaoSDKUser
import KakaoSDKAuth

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var iconTextLabel: UILabel!
    @IBOutlet private weak var kakaoLoginView: UIView!
    @IBOutlet private weak var appleLoginStackView: UIStackView!
    
    private let keyChainManager = KeyChainManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareIconTextLabel()
        prepareKakaoLoginView()
        prepareKakaoLoginViewTapGesture()
        prepareAppleLoginStackView()
    }
    
    private func prepareAppleLoginStackView() {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
        appleLoginStackView.addArrangedSubview(button)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(appleLoginStackViewTapped))
        appleLoginStackView.addGestureRecognizer(tapGesture)
        appleLoginStackView.isUserInteractionEnabled = true
        
        appleLoginStackView.layer.masksToBounds = false
        appleLoginStackView.layer.cornerRadius = 8
        appleLoginStackView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        appleLoginStackView.layer.shadowOffset = CGSize(width: 0, height: 12)
        appleLoginStackView.layer.shadowOpacity = 0.25
        appleLoginStackView.layer.shadowRadius = 14
    }
    
    private func prepareIconTextLabel() {
        iconTextLabel.transform = CGAffineTransform(rotationAngle: -(.pi/8))
    }
    
    private func prepareKakaoLoginView() {
        kakaoLoginView.layer.masksToBounds = false
        kakaoLoginView.layer.cornerRadius = 8
        kakaoLoginView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        kakaoLoginView.layer.shadowOffset = CGSize(width: 0, height: 12)
        kakaoLoginView.layer.shadowOpacity = 0.25
        kakaoLoginView.layer.shadowRadius = 14
    }
    
    private func prepareKakaoLoginViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(kakaoLoginViewTapped))
        kakaoLoginView.isUserInteractionEnabled = true
        kakaoLoginView.addGestureRecognizer(tapGesture)
    }
    
    @objc func appleLoginStackViewTapped() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self as ASAuthorizationControllerDelegate
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    @objc func kakaoLoginViewTapped() {
        // 카카오톡 설치 여부 확인
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                
                guard let token = oauthToken else { return }
                
                self.keyChainManager.accessToken = token.accessToken
                print(token)
                
                // 서버에 Access Token 전달 후 회원가입 확인
                ZipkokApi.shared.kakaoLogin(token: token.accessToken, completionHandler: { [weak self] response in
                    guard let self = self else { return }
                    
                    if response.isSuccess {
                        
                        guard let locationVc = LocationViewController.storyboardInstance() else {
                            fatalError()
                        }
                        
                        locationVc.loginType = .kakao
                        self.navigationController?.pushViewController(locationVc, animated: true)
                    }
                    else {
                        print("---> 로그인 카카오 에러")
                    }
                })
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityTokenData = credential.identityToken,
           let authorizationCodeData = credential.authorizationCode,
           let identityToken = String(data: identityTokenData, encoding: .utf8),
           let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) {
            
            var name: String = "익명"
            
            if let familyName = credential.fullName?.familyName, let givenName = credential.fullName?.givenName {
                name = "\(familyName) \(givenName)"
            }
            
            print("email", credential.email)
            print("user", credential.user)
            print("user", credential.fullName)
            print("identityToken", identityToken)
            print("authorizationCode", authorizationCode)
            
            ZipkokApi.shared.appleLogin(token: identityToken, code: authorizationCode, user: credential.user) { appleLoginResponse in
                
                if appleLoginResponse.isSuccess {                    
                    guard let locationVc = LocationViewController.storyboardInstance() else {
                        fatalError()
                    }
                    
                    locationVc.appleLoginInfo = AppleLoginInfo(id: credential.user, email: credential.email ?? "", fullName: name)
                    locationVc.loginType = .apple
                    self.navigationController?.pushViewController(locationVc, animated: true)
                } else {
                    print("apple login error")
                }
            }
        }
    }
}
