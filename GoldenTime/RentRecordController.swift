//
//  RentRecordController.swift
//  GoldenTime
//
//  Created by ramy nasser on 7/20/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
class RentRecordController: UITableViewController {
    
    var records = [Collection]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("while entering rent record")
        if let proper = keychainWrapper.string(forKey: "PropertiesID") {
            let str = String(proper)
            self.fetchnRecod(endpoint: str!)
            print("enter parsing in Rent")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func fetchnRecod(endpoint:String) {
        
        if let  token =  keychainWrapper.string(forKey: "accessToken") {
            var statusCode: Int = 0
            let headers: HTTPHeaders = [
                "x-access-Token": "\(token)",
            ]
            Alamofire.request("http://goldenxtime.herokuapp.com/api/1/m/properties/".appending(endpoint).appending("/rent"), method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                print("enter one current")
                let url = "http://goldenxtime.herokuapp.com/api/1/m/properties/".appending(endpoint).appending("/rent")
                print("the final url \(url)")
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
                    print("enter two current ")

                    var id:Int?
                    var type :String?
                    var given: Int?
                    
                    var notes:String?
                    var rent_id:Int?
                    var created_at:String?
                    var type_display_name: String?
                    
                    let postData = JSON(value)
                    print("the current data is  \(postData)")
                    print("the count of current object is \(postData.count)")
                    let current_rent_object =  JSON(value["current_rent"]).array
                    print("the count of current object is \(current_rent_object?.count)")
                    for i in 0..<(current_rent_object?.count)! {
                        print("enter three current")
                        
                        let object = current_rent_object?[i]["collections"].array
                        print("the count of current object is\(object?.count)")

                        let collectionData =  JSON(object)
                        print("the count of current object is\(collectionData.count)")

                        for index in 0..<collectionData.count{
                            if let Id = collectionData[index]["id"].int {
                             id = Id
                            }else{
                            id = 0
                            }
                            
                            
                            
                            if let Type = collectionData[index]["type"].string {
                                type = Type
                            }else{
                                type = Type
                            }
                            
                            //given
                            if let Given = collectionData[index]["given"].int {
                                given = Given
                            }else{
                                given = 0
                            }
                            //notes
                            if let Notes = collectionData[index]["notes"].string {
                                notes = Notes
                            }else{
                                notes = ""
                            }
                            
                            //rent_id
                            if let rentid = collectionData[index]["rent_id"].int {
                                rent_id = rentid
                            }else{
                                rent_id = 0
                            }
                            
                            //created_at
                            if let createdat = collectionData[index]["created_at"].string {
                                created_at = createdat
                            }else{
                                created_at = ""
                            }
                            
                            //created_at
                            if let typedisplayname = collectionData[index]["type_display_name"].string {
                                type_display_name = typedisplayname
                            }else{
                                type_display_name = ""
                            }

                            
                            //type_display_name
                            
                             let record = Collection(id: id, type: type, given: given, notes: notes, rent_id: rent_id, created_at: created_at, type_display_name: type_display_name)
                        self.records.append(record)
                        
                        self.tableView.reloadData()
                        
                        
                    }
                    self.tableView.reloadData()
                    
                    
                }
                self.tableView.reloadData()
                
            }
                self.tableView.reloadData()
   
        }
            self.tableView.reloadData()

    }
        self.tableView.reloadData()
        
        print("count of record is \(records.count)")
    
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
        return records.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! notificationCell
        
        let record = self.records[indexPath.row]
       
        if indexPath.row == records.count-1{
            cell.FirstVerticalView.isHidden = false
            cell.SecondVerticalView.isHidden = true
            cell.imageview.image = UIImage(named: "dot-and-circle")
            
        }else{
            cell.FirstVerticalView.isHidden = false
            cell.SecondVerticalView.isHidden = false

            
        cell.imageview.image = UIImage(named: "circle")
        }
        cell.dateLabel.text = record.created_at
        cell.titleLabel.text = "طريقة تحصيل \(record.type_display_name!)"
        cell.descriptionLabel.text = "تم تحصيل \(record.given!)"
        
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
