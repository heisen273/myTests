//
//  LoginViewController.swift
//  PinterestSwift
//
//  Created by Walter White on 2/15/17.
//  Copyright © 2017 Nicholas Tau. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let layout = CHTCollectionViewWaterfallLayout()
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func login(_ sender: Any) {
        let VC = NTWaterfallViewController(collectionViewLayout: layout)
        VC.numberOfItemsPerSection = 10
        VC.needLabel = false
        //VC.slideShow =
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //VC.setupImages()
        VKNetworking.shared.vkLogin {_ in 
            if true{
            appDelegate.get_json()
                self.navigationController?.pushViewController(VC, animated: true)
        }
        
        
        
        
        }}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
