//
//  mainViewController.swift
//  SIGNET
//
//  Created by Rami on 2/19/17.
//  Copyright © 2017 Mohamed Farouk Code95. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
class MainController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstViewController = self.storyboard!.instantiateViewController(withIdentifier: "profileController")as! profileController
        let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "FlatsController")as! FlatsController
        let thirdViewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificationController")as! NotificationController

        

        //profileController
        let customTabBarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "1")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "1"))
        firstViewController.tabBarItem = customTabBarItem

        let customTabBarItem2:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "2")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "2"))
        secondViewController.tabBarItem = customTabBarItem2
        
        let customTabBarItem3:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "3")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "3"))
        thirdViewController.tabBarItem = customTabBarItem3

//        self.tabBar.tintColor = UIColor.white

        
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
