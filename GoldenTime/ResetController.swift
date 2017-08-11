//
//  ResetController.swift
//  GoldenTime
//
//  Created by ramy nasser on 6/20/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit
import TextFieldEffects
import AlamofireImage
import Alamofire
import SwiftyJSON
class ResetController: UIViewController ,UITextFieldDelegate{

    @IBAction func SendEmail(_ sender: AnyObject) {
        
        if (validtor()){
            
            if let text = resetEmailField.text {
            var statusCode: Int = 0
            
            let headers: HTTPHeaders = [
                
                "Content-Type":"application/json",
                
                ]
            
            
            let parmeters = [
                
                "email": "\(text)",
                
            ]
            
            
                Alamofire.request("http://goldenxtime.herokuapp.com/api/1/reset-password", method: .post, parameters: parmeters, encoding: JSONEncoding.default)
                .responseJSON { (response) in
                    //Gets HTTP status code, useful for debugging
                    if let value: AnyObject = response.result.value as AnyObject? {
                        //Handle the results as JSON
                        let post = JSON(value)
                        print(JSON(value))
                        
                        if response.response?.statusCode == 200 {
                            let view = self.storyboard!.instantiateViewController(withIdentifier: "LoginController")as! LoginController
                            self.present(view, animated: true, completion: nil)
                        
                        }else {
                            
                            DataUtlis.data.ErrorDialog(Title: "خطآ", Body: "ايميل غير مسجل")

                        //ايميل غير مسجل
                        }
                        
                        
                    }
            }
            }
        
        }        else {
        }
            

}

    
   
    @IBOutlet weak var resetEmailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.resetEmailField.delegate = self
        
        let myColor : UIColor = UIColor(rgb: 0xEFCC63)
        resetEmailField.layer.borderColor = myColor.cgColor
        resetEmailField.layer.borderWidth = 2.0
        resetEmailField.layer.cornerRadius = 5.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.resetEmailField.resignFirstResponder()
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        // textField.resignFirstResponder()
        self.resetEmailField.resignFirstResponder()
        
        
        
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
        
        if (resetEmailField.text?.isEmpty)! {
            
            DataUtlis.data.ErrorDialog(Title: "Error", Body: "Empty Field For Reset field")
            valid = false
            
        }
            
       
            
            
        else {
            valid = true
        }
        return valid
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
