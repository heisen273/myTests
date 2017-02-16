//
//  VKNetworking.swift
//  PinterestSwift
//
//  Created by Walter White on 2/15/17.
//  Copyright © 2017 Nicholas Tau. All rights reserved.
//

import Foundation
import VK_ios_sdk
import UIKit

class VKNetworking: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    static let shared = VKNetworking()
    static let kVK_APP_ID = "5876362"
    
    
    
    let permissions = NSArray(objects: "email", "wall", "photos") as [AnyObject]

    var userEmail = String()
    
    func vkLogin(completion: @escaping (Bool) -> ()) {
        VKSdk.wakeUpSession(self.permissions, complete: { (state, error) in
            if state == .authorized && error == nil && VKSdk.accessToken() != nil {
                print("vk authorized")
                completion(true)
            } else if state == .initialized {
                print("vk initialized")
                VKSdk.authorize(self.permissions)
            } else {
                if error != nil {
                    print(error!)
                }
                completion(false)
            }
        })
    }
    
    func vkLogout() {
        VKSdk.forceLogout()
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil && result.error == nil {
            if let email = result.token.email {
                self.userEmail = email
            }
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("vkSdkUserAuthorizationFailed")
        
    }
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        //let top: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        let tabBar = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        
        tabBar?.present(controller, animated: true, completion: nil)
        
        //top?.present(controller,animated:true,completion:nil)
    }
    
    
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
}
