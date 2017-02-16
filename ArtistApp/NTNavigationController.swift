//
//  NTNavigationController.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 7/2/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

import Foundation
import UIKit
class NTNavigationController : UINavigationController{
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let childrenCount = self.viewControllers.count
        let tabBar = self.viewControllers[0] as! UITabBarController
        return super.popViewController(animated: true)
    }
}
