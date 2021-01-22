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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let loginNavVc = LoginNavigationViewController.storyboardInstance(),
              let homeNavVc = HomeNavigationViewController.storyboardInstance(),
              let splashVc = SplashViewController.storyboardInstance() else {
            fatalError()
        }
        
        let keyChainManager = KeyChainManager()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = splashVc
        window.makeKeyAndVisible()
        self.window = window
        
        if let jwtToken = keyChainManager.jwtToken { // jwt token 이 있을 때
            ZipkokApi.shared.jwtLogin(jwt: jwtToken) { jwtLoginResponse in
                if jwtLoginResponse.isSuccess {
                    homeNavVc.modalPresentationStyle = .fullScreen
                    window.rootViewController = homeNavVc
                } else { // jwt token 이 유효하지 않을 때
                    loginNavVc.modalPresentationStyle = .fullScreen
                    window.rootViewController = loginNavVc
                }
            }
        } else { // jwt token 이 없으면
            guard let loginNavVc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? UINavigationController else {
                fatalError()
            }
            loginNavVc.modalPresentationStyle = .fullScreen
            window.rootViewController = loginNavVc
        }
        
        self.window = window
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

