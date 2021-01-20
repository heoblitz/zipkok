//
//  ViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/09.
//

import UIKit
import SwiftKeychainWrapper

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func requestCoordButtonTapped() {
        GeoCodingApi.shared.requestCoord(by: "석계로 49") { x, y in
            print(x, y)
        }
    }
    
    @IBAction func requestRegioncode() {
        GeoCodingApi.shared.requestRegioncode(by: (127.06253874566, 37.6172252018111), completionHandler: { addressName in
            print(addressName)
        })
    }
    
    @IBAction func kakaoLogin() {
        ZipkokApi.shared.kakaoLogin(token: "a", completionHandler: { _ in
            
        })
    }
    
    @IBAction func SelectChallengeViewController() {
        guard let vc = UIStoryboard(name: "SelectChallenge", bundle: nil).instantiateInitialViewController() as? SelectChallengeViewController else { fatalError() }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

