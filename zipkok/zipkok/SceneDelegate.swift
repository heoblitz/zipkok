//
//  SceneDelegate.swift
//  zipkok
//
//  Created by won heo on 2021/01/09.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    //    let isTestMode = false
    //
    //    if isTestMode {
    //        let window = UIWindow(windowScene: windowScene)
    //
    //        window.rootViewController = testVc
    //        window.makeKeyAndVisible()
    //        self.window = window
    //    } else {
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let homeNavVc = HomeNavigationViewController.storyboardInstance(),
              let splashVc = SplashViewController.storyboardInstance(),
              let selectChallengeVc = SelectChallengeViewController.storyboardInstance(),
              let timerVc = TimerViewController.storyboardInstance() else {
            fatalError()
        }
        
        let keyChainManager = KeyChainManager()
        prepareFirebaseToken()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = splashVc
        window.makeKeyAndVisible()
        self.window = window
        
        if let jwtToken = keyChainManager.jwtToken { // jwt token 이 있을 때
            ZipkokApi.shared.jwtLogin(jwt: jwtToken, errorHandler: {
                self.setLogin(window)
                return
            }) { jwtLoginResponse in
                if jwtLoginResponse.isSuccess, jwtLoginResponse.code == 1014 { // jwt token 이 유효할 때
                    ZipkokApi.shared.challengeTime(jwt: jwtToken) { challengeTimeResponse in
                        if challengeTimeResponse.code == 1000,
                           let result = challengeTimeResponse.result,
                           let startDate = result.startDate,
                           let endDate = result.endDate { // 챌린지가 있을 때
                            
                            homeNavVc.pushViewController(selectChallengeVc, animated: false)
                            selectChallengeVc.navigationItem.backButtonTitle = ""
                            timerVc.isActiveFromBackground = true
                            timerVc.challengeIdx = result.challengeIdx
                            timerVc.startDate = startDate
                            timerVc.endDate = endDate
                            
                            homeNavVc.pushViewController(timerVc, animated: false)
                            timerVc.navigationItem.backButtonTitle = ""
                            window.rootViewController = homeNavVc
                            return
                        } else { // 챌린지가 없을 때
                            self.setHome(window)
                            return
                        }
                    }
                }
            }
        }
        
        setLogin(window)
    }
    
    func setHome(_ window: UIWindow) {
        guard let homeNavVc = HomeNavigationViewController.storyboardInstance() else { return }
        
        homeNavVc.modalPresentationStyle = .fullScreen
        window.rootViewController = homeNavVc
        self.window = window
    }
    
    func setLogin(_ window: UIWindow) {
        guard let loginNavVc = LoginNavigationViewController.storyboardInstance() else { return }
        
        loginNavVc.modalPresentationStyle = .fullScreen
        window.rootViewController = loginNavVc
        self.window = window
    }
    
    func prepareFirebaseToken() {
        let keyChainManager = KeyChainManager()
        // firebase token 지정
        if let fcmToken = keyChainManager.fcmToken, let jwtToken = keyChainManager.jwtToken {
            ZipkokApi.shared.registerFirebaseToken(jwt: jwtToken, token: fcmToken) { registerFirebaseTokenResponse in
                if registerFirebaseTokenResponse.isSuccess {
                    // dateManager.isNotAppFirstLaunched = true
                    print(registerFirebaseTokenResponse.message)
                }
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

