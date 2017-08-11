//
//  profileController.swift
//  GoldenTime
//
//  Created by ramy nasser on 6/19/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON
class profileController: UIViewController , UITableViewDelegate , UITableViewDataSource,SecondProfileDelegate {
    internal func cellTapped(cell: SecondProfileCell) {
        print("data")
        print("the mobile \(cell.MobileLabel.titleLabel)")
        if let  token =  keychainWrapper.string(forKey: "accessToken") {
            
            var statusCode: Int = 0
            
            let headers: HTTPHeaders = [
                
                "Content-Type":"application/json",
                 "x-access-Token": "\(token)"
                ]
            
            
        
            
            Alamofire.request("http://goldenxtime.herokuapp.com/api/1/m/request-verify-code", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { (response) in
                    print("the 1")
                    //Gets HTTP status code, useful for debugging
                    if let value: AnyObject = response.result.value as AnyObject? {
                        //Handle the results as JSON
                        print("the \(value)")

                        if response.response?.statusCode == 200 {

                            
                            if let person = self.person{
                            
                                if person.phoneVerified == 0 {
                                    self.ShowVerifyAlert()

                                }
                            }
                        }
                        else if  response.response?.statusCode == 401 {
                            UiHelpers.hideLoader()
                            
                            DataUtlis.data.ErrorDialog(Title: "الحساب معطل ", Body: "برجاء التواصل مع الادارة")
                            
                        }
                        else {
                            
                            UiHelpers.hideLoader()
                            print("the status code \(response.response?.statusCode)")
                            DataUtlis.data.ErrorDialog(Title: "انقطاع ف الانترنت", Body: "برجاء فحص الانترنت")
                            
                        }
                    }
            }
        }
    }


   
    @IBOutlet weak var PhoneLabel: UIButton!
    @IBOutlet weak var tableview: UITableView!
    var person:Profile?
    var image :UIImage?
    var data :NSData?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self 
        fetchRofile()

    }
    @IBAction func Logout(_ sender: AnyObject) {
    keychainWrapper.removeObject(forKey: "accessToken")
        let view = self.storyboard!.instantiateViewController(withIdentifier: "LoginController")as! LoginController
        self.present(view, animated: true, completion: nil)
        

    }

    func retrieveImage(Endpoint:String,headers: HTTPHeaders) {
        var imgData: NSData!

        Alamofire.request(Endpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseImage { response in
            debugPrint(response)
            
            print("the request \(response.request)")
            print("the response \(response.response)")
            debugPrint(response.result)
            
            
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                
                imgData = NSData(data:UIImageJPEGRepresentation(image, 0.2)!)
                
                if let data = imgData {
                    print("Size of Image: \(self.data) bytes")
                    
                    self.data = data

                    
                }
                else {
                    
                }
                self.tableview.reloadData()
            }
        }

        
    }
    
    func fetchRofile() {

        let BaseURL = "https://goldenxtime.herokuapp.com/static/"

        if let  token =  keychainWrapper.string(forKey: "accessToken") {
            var statusCode: Int = 0
            let headers: HTTPHeaders = [
                "x-access-Token": "\(token)",
            ]
                        Alamofire.request("http://goldenxtime.herokuapp.com/api/1/m/profile", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                print("enter one ")
                            if  response.response?.statusCode == 401 {
                                UiHelpers.hideLoader()

                                DataUtlis.data.ErrorDialog(Title: "الحساب معطل ", Body: "برجاء التواصل مع الادارة")
                                keychainWrapper.removeObject(forKey: "accessToken")
                                let view = self.storyboard!.instantiateViewController(withIdentifier: "LoginController")as! LoginController
                                self.present(view, animated: true, completion: nil)
                                
                            }

                if let json = response.result.value as? [String: Any] {
                    print(json)
                    
                   
                    }
                    
                
                else{
                    print("error \(response.error)")
                }
                
                if let value: AnyObject = response.result.value as AnyObject? {
                    //Handle the results as JSON
                    let postData = JSON(value)
                    print(postData)
                    print(postData.count)
                   
                    if let id = postData["id"].int ,
                        let name = postData["name"].string ,
                        let email = postData["email"].string ,
                        let emailVerified = postData["email_verified"].int ,
                        let phone = postData["phone"].string ,
                        let phoneVerified = postData["phone_verified"].int ,
                        let landline = postData["landline"].string ,
                        let picture = postData["picture"].string

                        {
                            print("the id \(id)")
                            if let address = postData["address"].string {
                                print("the address \(address)")
                                
                                let finalurl = BaseURL.appending(picture)
                              
                                 self.retrieveImage(Endpoint: finalurl, headers: headers)
    
                                
                                self.person = Profile(id: id, name: name, email: email, emailVerified: emailVerified, phone: phone, phoneVerified: phoneVerified, landline: landline, address: address, picture: picture)
                                self.tableview.reloadData()

                            }
                            else {
                                self.person = Profile(id: id, name: name, email: email, emailVerified: emailVerified, phone: phone, phoneVerified: phoneVerified, landline: landline, address: "لايوجد", picture: picture)
                                
                                let finalurl = BaseURL.appending(picture)
                                
                                 self.retrieveImage(Endpoint: finalurl, headers: headers)

                                self.tableview.reloadData()
                                
                            }

                    
                    }
                    else {
                    self.tableview.reloadData()

                 
                    }
                    self.tableview.reloadData()



                }
                self.tableview.reloadData()


 
            }
            self.tableview.reloadData()


        }

        
                }
    
   
    
    
    func ShowVerifyAlert(){
        
        let alertController = UIAlertController(title: "من فضلك ادخل  كود التاكيد", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "تاكيد", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            if let code = firstTextField.text {
                if let  token =  keychainWrapper.string(forKey: "accessToken") {
                    
                    
                    
                    var statusCode: Int = 0
                    
                    let headers: HTTPHeaders = [
                        
                        "Content-Type":"application/json",
                        "x-access-Token": "\(token)"
                    ]
                    
                    
                    let parmeters = [
                        
                        "code": code
                        
                    ]
                    
                    
                    
                    Alamofire.request("http://goldenxtime.herokuapp.com/api/1/m/verify-code", method: .post, parameters: parmeters, encoding: JSONEncoding.default, headers: headers)
                        .responseJSON { (response) in
                            print("the 1")
                            //Gets HTTP status code, useful for debugging
                            if let value: AnyObject = response.result.value as AnyObject? {
                                //Handle the results as JSON
                                print("the \(value)")
                                
                                if response.response?.statusCode == 200 {
                                    DataUtlis.data.SuccessDialog(Title: "نجاح العملية", Body: "تم تفعيل الهاتف بنجاح")
                                    self.fetchRofile()

                                    
                                }
                                else if  response.response?.statusCode == 401 {
                                    UiHelpers.hideLoader()
                                    
                                    DataUtlis.data.ErrorDialog(Title: "الحساب معطل ", Body: "برجاء التواصل مع الادارة")
                                    
                                }
                                else {
                                    
                                    UiHelpers.hideLoader()
                                    print("the status code \(response.response?.statusCode)")
                                    DataUtlis.data.ErrorDialog(Title: "انقطاع ف الانترنت", Body: "برجاء فحص الانترنت")
                                    
                                }
                            }
                    }
                }
                

            }
            
            
        })
        alertController.addTextField { (textField : UITextField!) -> Void in
        }
        let cancelAction = UIAlertAction(title: "الغاء", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        

        
            }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstProfileCell", for: indexPath) as! FirstProfileCell
            
            if let person = self.person {
            cell.NameLabel.text = person.name
                let url = "https://goldenxtime.herokuapp.com/static/"

                if let dataimage = self.data {
            cell.ProfileImage.image = UIImage(data: dataimage as! Data)
                    print("imageeeeeeeeeeee")
               }
                else {

                }
            
            }
            // Configure the cell...
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondProfileCell", for: indexPath) as! SecondProfileCell
            //ic_verifiedell
            if let person = self.person {

            cell.EmailLabel.text = person.email
            cell.MobileLabel.setTitle(person.phone, for: .normal)
                if cell.ProfileDelegate == nil {
                    cell.tag = indexPath.row
                    cell.ProfileDelegate = self
                }
            cell.TeleLabel.text = person.landline
            cell.LocationLabel.text = person.address
                if person.emailVerified == 0 {
                cell.emailVerified.image = UIImage(named: "ic_unverfied")
                }
                else {
                cell.emailVerified.image = UIImage(named: "ic_verified")
                }
                if person.phoneVerified == 0 {
                    cell.phoneVerified.image = UIImage(named: "ic_unverfied")

                }
                else {
                    cell.phoneVerified.image = UIImage(named: "ic_verified")

                }
                
                //ic_unverfied
                
            }
            return cell
            
            
        }
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 354
            
        }
        else {
            return 221
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tableview.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.reloadData()

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
