//
//  NotificationController.swift
//  GoldenTime
//
//  Created by ramy nasser on 6/20/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
class NotificationController: UITableViewController {
   
var notifs = [NotificationModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
fetchnotification()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    func fetchnotification() {
        
        if let  token =  keychainWrapper.string(forKey: "accessToken") {
            var statusCode: Int = 0
            let headers: HTTPHeaders = [
                "x-access-Token": "\(token)",
            ]
            Alamofire.request("http://goldenxtime.herokuapp.com/api/1/m/notifications", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                print("enter one ")
                if  response.response?.statusCode == 401 {
                    UiHelpers.hideLoader()

                    DataUtlis.data.ErrorDialog(Title: "الحساب معطل ", Body: "برجاء التواصل مع الادارة")
                    keychainWrapper.removeObject(forKey: "accessToken")
                    let view = self.storyboard!.instantiateViewController(withIdentifier: "LoginController")as! LoginController
                    self.present(view, animated: true, completion: nil)
                    
                }

                if let value: AnyObject = response.result.value as AnyObject? {
                    //Handle the results as JSON
                    var Id: Int?
                    var Title : String?
                    var Body : String?
                    var Type : String?
                    var PropertyId : Int?
                    var Date:String?
                    var Owner_id: Int?
                    print("enter tow ")

                    
                    let postData = JSON(value)
                    print(postData)
                    print(postData.count)
                    
                    for i in 0..<(postData.count) {
                        print("enter three ")

                        
                        if let id = postData[i]["id"].int {
                        Id = id
                        }else{
                            Id = 0
                        }
                        if let title = postData[i]["title"].string {
                        Title = title
                        }else{
                        Title = ""
                        }
                        if let body = postData[i]["body"].string {
                        Body = body
                        }else{
                            Body = ""
                        }
                        if let type = postData[i]["type"].string {
                        Type = type
                        }else {
                            Type = ""
                        }
                        if let propertyId = postData[i]["propertyId"].int {
                        PropertyId = propertyId
                        }else {
                        PropertyId = 0
                        }
                        if let date = postData[i]["date"].string {
                        Date = date
                        }else {
                        Date = ""
                        }
                        if let owner_id = postData[i]["owner_id"].int{
                            Owner_id = owner_id
                        }else{
                        Owner_id = 0
                        }
                        let no = NotificationModel(id: Id, title: Title, body: Body, type: Type, propertyId: PropertyId, date: Date, owner_id: Owner_id)
                        self.notifs.append(no)
                   
                    self.tableView.reloadData()
                    
                    
                }
                self.tableView.reloadData()
                
                
            }
            self.tableView.reloadData()
            
        }
        
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! notificationCell
        let not = self.notifs[indexPath.row]
        if indexPath.row == notifs.count-1{
            cell.FirstVerticalView.isHidden = false
            cell.SecondVerticalView.isHidden = true
            cell.imageview.image = UIImage(named: "dot-and-circle")
            
        }else{
            cell.imageview.image = UIImage(named: "circle")
        }
        cell.dateLabel.text = not.date
        cell.titleLabel.text = not.title
    
        cell.descriptionLabel.text = not.body

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
