//
//  Data.swift
//  SIGNET
//
//  Created by ramy nasser on 4/21/17.
//  Copyright © 2017 Mohamed Farouk Code95. All rights reserved.
//

import Foundation
import SwiftMessages
import UIKit
import Alamofire
import SwiftyJSON
import Alamofire

class DataUtlis {
    static var data = DataUtlis()
    func isValidEmail(Email:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: Email)
    }
    
    
    func SuccessDialog(Title:String ,Body:String ){
        let success = MessageView.viewFromNib(layout: .CardView)
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: Title, body: Body)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .bottom
        successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        SwiftMessages.show(config: successConfig, view: success)
        
        
    }
    
    func ErrorDialog(Title:String ,Body:String ){
        let success = MessageView.viewFromNib(layout: .CardView)
        success.configureTheme(.error)
        success.configureDropShadow()
        success.configureContent(title: Title, body: Body)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .bottom
        successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        SwiftMessages.show(config: successConfig, view: success)
        
        
    }
    
    
}
