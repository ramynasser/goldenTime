//
//  aboutController.swift
//  GoldenTime
//
//  Created by ramy nasser on 7/12/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON
class aboutController: UITableViewController {
    var proper:Property?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let id  = keychainWrapper.string(forKey: "PropertiesID") {
            print("about")
            fetchFlats(endpoint: id)
            self.tableView.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    var properties = [Property]()
    var data = [NSData]()
    
   
    
    func retrieveImage(Endpoint:String,headers: HTTPHeaders) {
        var imgData: NSData!
        
        Alamofire.request(Endpoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseImage { response in
            debugPrint(response)
            
            print("the request \(response.request)")
            print("the response \(response.response)")
            debugPrint(response.result)
            
            
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                
                imgData = NSData(data: UIImageJPEGRepresentation(image, 0.2)!)
                
                if let data = imgData {
                    print("Size of Image: \(self.data) bytes")
                    
                    self.data.insert(data, at: 0)
                    self.tableView?.reloadData()
                    
                }
                else {
                    
                }
                self.tableView?.reloadData()
            }
        }
        
        
    }
    
    
    func fetchFlats(endpoint:String) {
        
        if let  token =  keychainWrapper.string(forKey: "accessToken") {
            var statusCode: Int = 0
            let headers: HTTPHeaders = [
                "x-access-Token": "\(token)",
            ]
            Alamofire.request("http://goldenxtime.herokuapp.com/api/1/m/properties/".appending(endpoint), method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
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
                    let postData = JSON(value)
                    print("the count of about \(postData.count)")
                    print(postData)
                    
                    var Id: Int?
                    var Name : String?
                    var Unit_id: Int?
                    var Unit_type : String?
                    var Class_type : String?
                    var Area: String?
                    var Address :String?
                    var Notes:String?
                    var Rented : Int?
                    var Rentable: Int?
                    var Top_level: Int?
                    var Parent_property_id: Int?
                    var Owner_id: Int?
                    var Photo = [Photos]()
                    var Detail =  [Details]()
                    
                    
                    for i in 0..<(postData.count) {
                        
                        var Photoid:Int?
                        var PhotoFile:String?
                        //
                        let PhotoObject  = postData[i]["photos"].array
                        
                        let PhotosJson = JSON(PhotoObject)
                        print("count of phot image \(PhotoObject?.count)")
                        
//                        if (PhotoObject?.count)! > 0 {
//                            if let id = PhotosJson[0]["id"].int ,
//                                let filename = PhotosJson[0]["file"].string {
//                                Photoid = id
//                                PhotoFile = filename
//                                var Photo = Photos(id: Photoid!, file: PhotoFile!)
//                                let BaseURL = "https://goldenxtime.herokuapp.com/static/"
//                                let final = BaseURL.appending((Photo.file))
//                                
//                                self.retrieveImage(Endpoint: final, headers: headers)
//                                print("donnnnnnne")
//                            }
//                            else {
//                                print("no donnnnnnne2")
//                                Photoid = 0
//                                PhotoFile = "property.jpg"
//                                var Photo = Photos(id: Photoid!, file: PhotoFile!)
//                                print("no donnnnnnne")
//                                let BaseURL = "https://goldenxtime.herokuapp.com/static/"
//                                print("tr")
//                                let final = BaseURL.appending((Photo.file))
//                                print(final)
//                                print("tr2")
//                                
//                                self.retrieveImage(Endpoint: final, headers: headers)
//                                
//                            }
//                        }
//                        else {
//                            print("no donnnnnnne2")
//                            Photoid = 0
//                            PhotoFile = "property.jpg"
//                            var Photo = Photos(id: Photoid!, file: PhotoFile!)
//                            print("no donnnnnnne")
//                            let BaseURL = "https://goldenxtime.herokuapp.com/static/"
//                            print("tr")
//                            let final = BaseURL.appending((Photo.file))
//                            print(final)
//                            print("tr2")
//                            
//                            self.retrieveImage(Endpoint: final, headers: headers)
//                            
//                            
//                            
//                        }
//                        
                        for index in 0...PhotosJson.count {
                            if let id = PhotosJson[index]["id"].int ,
                                let filename = PhotosJson[index]["file"].string {
                                Photoid = id
                                PhotoFile = filename
                                Photo.append(Photos(id: Photoid!, file: PhotoFile!))
                                
                                
                                let BaseURL = "https://goldenxtime.herokuapp.com/static/"
                                
                                
                                print("donnnnnnne")
                            }
                            else {
                                print("no donnnnnnne2")
                                Photoid = 0
                                PhotoFile = "property.jpg"
                                Photo.append(Photos(id: Photoid!, file: PhotoFile!))
                                print("no donnnnnnne")
                               
                                
                                
                                
                                
                            }
                            
                        }
                        
                        if let id = postData["id"].int  {
                            Id = id
                        }
                        else {
                            Id = 0
                        }
                        if let name = postData["name"].string  {
                            Name = name
                        }
                        else
                        {
                            Name = ""
                        }
                        if let unit_id = postData["unit_id"].int {
                            Unit_id = unit_id
                        }
                        else {
                            Unit_id = 0
                        }
                        if let unit_type = postData["unit_type"].string  {
                            Unit_type = unit_type
                        }
                        else {
                            Unit_type = ""
                        }
                        if let classType = postData["class"].string  {
                            Class_type = classType
                        }
                        else {
                            Class_type = ""
                            
                        }
                        if let area = postData["area"].string {
                            
                            Area = area
                        }
                        else {
                            Area = ""
                        }
                        if let address = postData["address"].string {
                            Address = address
                        }
                        else {
                            Address = ""
                        }
                        if let rented = postData["rented"].int {
                            Rented = rented
                        }
                        else {
                            Rented = 0
                        }
                        
                        if let rented = postData["rentable"].int {
                            Rentable = rented
                        }
                        else {
                            Rentable = 0
                        }
                        if let top_level = postData["top_level"].int {
                            Top_level = top_level
                        }
                        else {
                            Top_level = 0
                        }
                        //  let parent_property_id = postData["parent_property_id"].string
                        if let owner_id = postData["owner_id"].int {
                            Owner_id = owner_id
                        }
                        else {
                            Owner_id = 0
                        }
                        if let parent_property_id = postData["parent_property_id"].int
                        {
                            Parent_property_id = parent_property_id
                        }
                        else {
                            Parent_property_id = 0
                        }
                        if let notes = postData["notes"].string
                        {
                            Notes = notes
                        }
                        else {
                            Notes = ""
                        }
                        
                    }
                    
                        let DetailsObject  = postData["details"].array
                        let DetailsJson = JSON(DetailsObject)
                        
                        print("count of details \(DetailsJson.count)")
                    
                        for i in 0..<(DetailsJson.count) {
                            
                            if let key = DetailsJson[i]["key"].string,
                                let value = DetailsJson[i]["value"].int
                            {
                                
                                print("fetch data of details ")
                                let d = Details(key: key, value: value)
                                Detail.insert(d, at: 0)
                                if value > 0 {
                                let pro = Property(id: Id!, name: Name!, unit_id: Unit_id!, unit_type: Unit_type!, class_type: Class_type!, area: Area!, address: Address!, notes: Notes!, rented: Rented!, rentable: Rented!, top_level: Top_level!, parent_property_id: 1, owner_id: Owner_id!, photos: Photo, details: Detail)
                                self.proper = pro
                                self.tableView.reloadData()
                                print("the daaaaaataaaaaa in about is \(d.key)")
                                }
                                
                            }
                                
                                
                            else {
//                                let d = Details(key: "key", value: 0)
//                                Detail.insert(d, at: 0)
//                                
//                                let pro = Property(id: Id!, name: Name!, unit_id: Unit_id!, unit_type: Unit_type!, class_type: Class_type!, area: Area!, address: Address!, notes: Notes!, rented: Rented!, rentable: Rented!, top_level: Top_level!, parent_property_id: 1, owner_id: Owner_id!, photos: Photo!, details: Detail)
//                                self.proper = pro
//                                self.tableView.reloadData()
//
                                print("fetch data odassadf details  ")

                            }
                            
                            self.tableView.reloadData()
 
                        }
                        
                    
                    
                    self.tableView.reloadData()
                        print("detail count about \(Detail.count)")
                        print("the id \(Id)")
                        
                        // self.tableview.reloadData()
                        
                        
                    
                    // self.tableview.reloadData()
                    
                    
                }
                self.tableView.reloadData()

                
                
            }
            self.tableView.reloadData()

        }
        self.tableView.reloadData()

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
        if let proper = self.proper {
        return  proper.details.count + 3
        
        }
        else {
        return 0
        }

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row <= 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as! FirstCell

            if indexPath.row == 0 {
                cell.label.text = proper?.class_type
                cell.attributeImage.image = UIImage(named: "circle")
            
            }
            else if indexPath.row == 1 {
                cell.label.text = proper?.area
                cell.attributeImage.image = UIImage(named: "ic_location")
            }
            else {
                cell.label.text = "ملاحظات عامة"
                cell.attributeImage.image = UIImage(named: "info-solid-circular-button")
            
            }
            
            return cell
        
        }
        else {
        
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlatsDetailsCell", for: indexPath)
            as! FlatsDetailsCell
            cell.attributeLabel.text = self.proper?.details[indexPath.row-3].key
            if let value = self.proper?.details[indexPath.row-3].value{
            cell.ValueLabel.text = String(describing:value )

            }
            return cell

        }
        // Configure the cell...

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
