//
//  LoginController.swift
//  GoldenTime
//
//  Created by ramy nasser on 6/19/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit
import TextFieldEffects
import AwesomeButton
import Alamofire
import AlamofireImage
import SwiftyJSON

class LoginController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func login(_ sender: AnyObject) {
        if validtor() {
            UiHelpers.showLoader()
            if let username = usernameField.text , let password = passwordField.text {
                var statusCode: Int = 0

                let headers: HTTPHeaders = [

                    "Content-Type":"application/json",

                ]
                
                
                let parmeters = [
                    
                    "username": "\(username)",
                    "password": "\(password)"
                    
                ]
               
               
                Alamofire.request("http://goldenxtime.herokuapp.com/api/1/login", method: .post, parameters: parmeters, encoding: JSONEncoding.default)
.responseJSON { (response) in
                   //Gets HTTP status code, useful for debugging
                    if let value: AnyObject = response.result.value as AnyObject? {
                        //Handle the results as JSON
                        if  response.response?.statusCode == 401 {
                            UiHelpers.hideLoader()

                        DataUtlis.data.ErrorDialog(Title: "الحساب معطل ", Body: "برجاء التواصل مع الادارة")
//                            keychainWrapper.removeObject(forKey: "accessToken")
//                            let view = self.storyboard!.instantiateViewController(withIdentifier: "LoginController")as! LoginController
//                            self.present(view, animated: true, completion: nil)
//                            
                        }

                        let post = JSON(value)
                        print(JSON(value))
                        if let token = post["accessToken"].string {
                            
                            if   keychainWrapper.set(token, forKey: "accessToken")
                            {
                                UiHelpers.hideLoader()

                  let view = self.storyboard!.instantiateViewController(withIdentifier: "MainController")as! MainController
                  self.present(view, animated: true, completion: nil)

                            }
                        } else {
                            UiHelpers.hideLoader()

                           DataUtlis.data.ErrorDialog(Title: "خطا", Body: "كلمة السر او المرور خاطئة")
                            print("error \(response.error)")
                        }
                        
                    }
                }
            }
                
            else {
                DataUtlis.data.ErrorDialog(Title: "ERROR", Body: "NOT REGISTERED USER")
            }
            
        

    
            }
//            let view = self.storyboard!.instantiateViewController(withIdentifier: "MainController")as! MainController
//            
//            
//            self.present(view, animated: true, completion: nil)
            
        
    }
    @IBAction func GoToRestController(_ sender: AnyObject) {
        let view = self.storyboard!.instantiateViewController(withIdentifier: "ResetController")as! ResetController
        
        
        self.present(view, animated: true, completion: nil)
        
    }
    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.usernameField.delegate = self
       self.passwordField.delegate = self
        let myColor : UIColor = UIColor(rgb: 0xEFCC63)
        usernameField.layer.borderColor = myColor.cgColor
        passwordField.layer.borderColor = myColor.cgColor
        
        usernameField.layer.borderWidth = 2.0
        passwordField.layer.borderWidth = 2.0
        usernameField.layer.cornerRadius = 5.0
        passwordField.layer.cornerRadius = 5.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.usernameField.resignFirstResponder()
        
        self.passwordField.resignFirstResponder()
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        // textField.resignFirstResponder()
        self.usernameField.resignFirstResponder()
        
        self.passwordField.resignFirstResponder()
        
        
        return true
        
    }

    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
                
                
                
            }}
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func validtor() -> Bool {
        var valid = false
        
        if (usernameField.text?.isEmpty)! {
            
            DataUtlis.data.ErrorDialog(Title: "خطا", Body: "برجاء ادخال اسم المستخدم")
            valid = false
            
        }
            
        else if (passwordField.text?.isEmpty)! {
            
            DataUtlis.data.ErrorDialog(Title: "خطا", Body: "برجاء ادخال كلمة المرور")
            valid = false
            
        }
        
       
        else {
            valid = true
        }
        return valid
    }


}
