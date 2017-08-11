//
//  contractController.swift
//  GoldenTime
//
//  Created by ramy nasser on 6/29/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class contractController: UIViewController , UITableViewDelegate , UITableViewDataSource ,ButtonDelegate {
    internal func cellTapped(cell: FirstFlatsDetailsCell) {
        let index = cell.tag
        if let photos = self.detailRent[index].photos {
            if (photos.count)<=0{
            DataUtlis.data.ErrorDialog(Title: "خطا", Body: "لاتوجد صور للعقد")
            }else{
            
            //open photo browser
            }
        }else{
            DataUtlis.data.ErrorDialog(Title: "خطا", Body: "لاتوجد صور للعقد")

        }
    }

    var detailRent = [CurrentRent]()
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
                    print("the current  is  \(postData)")
                    print("the count of current is \(postData.count)")
                    let current_rent_object =  JSON(value["current_rent"]).array
                    print("the count of current  is \(current_rent_object?.count)")
                    for i in 0..<(current_rent_object?.count)! {
                        
                        var currentid: Int?
                        var currentrenter_name:String?
                        var currentstart_date:String?
                        var currentend_date:String?
                        var currenttype :String?
                        var currentvalue:Int?
                        var currentis_current:Int?
                        var currentproperty_id:Int
                        
                        
                        //    "case": [],
                        var photos: [Photos]?
                        var collections = [Collection]()
                        
                        
                        if let Id = current_rent_object?[i]["id"].int {
                            currentid = Id
                        
                        }else{
                            currentid = 0
                        }
                        if let Id = current_rent_object?[i]["renter_name"].string {
                            currentrenter_name = Id
                            print("the render name \(Id)")
                        }else{
                            currentrenter_name = "غير معروف"
                        }
                        if let Id = current_rent_object?[i]["start_date"].string {
                            currentstart_date = Id
                        }else{
                            currentstart_date = "غير معروف"
                        }
                        if let Id = current_rent_object?[i]["end_date"].string {
                            currentend_date = Id
                        }else{
                            currentend_date = "غير معروف"
                        }
                        if let Id = current_rent_object?[i]["type"].string {
                            currenttype = Id
                        }else{
                            currenttype = ""
                        }
                        if let Id = current_rent_object?[i]["value"].int {
                            currentvalue = Id
                        }else{
                            currentvalue = 0
                        }
                        if let Id = current_rent_object?[i]["is_current"].int {
                            currentis_current = Id
                        }else{
                            currentis_current = 0
                        }
                        if let Id = current_rent_object?[i]["property_id"].int {
                            currentproperty_id = Id
                        }else{
                            currentproperty_id = 0
                        }
                       
                        let Photosobject = current_rent_object?[i]["photos"].array
                        let PhotosData =  JSON(Photosobject)
                        var Photoid:Int?
                        var PhotoFile:String?
                        var Photo:Photos?
                        
                        
                        print("the number of image in contract \(PhotosData.count)")
                        for index in 0..<PhotosData.count{
                            
                            if (PhotosData.count) > 0 {
                                if let id = PhotosData[0]["id"].int ,
                                    let filename = PhotosData[0]["file"].string {
                                    Photoid = id
                                    PhotoFile = filename
                                    Photo = Photos(id: Photoid!, file: PhotoFile!)
                                    print("the number of image in contract \(PhotosData.count)")

                                }
                                else {
                                    print("the number of image in contract2 \(PhotosData.count)")

                                }
                            }
                            else {
                                //less than
                                print("the number of image in contract3 \(PhotosData.count)")

                            }

                        
                            
                            
                        let object = current_rent_object?[i]["collections"].array
                        print("the count of current object in contract is\(object?.count)")
                        
                        let collectionData =  JSON(object)
                        print("the count of current object in contract is\(collectionData.count)")
                        
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
                            collections.append(record)
                            
                            self.tableview.reloadData()
                            
                            
                        }
                let newrent = CurrentRent(id: currentid, renter_name: currentrenter_name, start_date: currentstart_date, end_date: currentend_date, type: currenttype, value: currentvalue, is_current: currentis_current, property_id: currentproperty_id, photos: photos, collections: collections)
                        self.tableview.reloadData()
                        
                        
                    }
                        
                        let new = CurrentRent(id: currentid, renter_name: currentrenter_name, start_date: currentstart_date, end_date: currentend_date, type: currenttype, value: currentvalue, is_current: currentis_current, property_id: currentproperty_id, photos: photos, collections: collections)
                        
                        self.detailRent.append(new)

                    self.tableview.reloadData()
                    
                }
                self.tableview.reloadData()
                
            }
            self.tableview.reloadData()
            
        }
        self.tableview.reloadData()
        
        
    }
        
        print("the count of data \(self.detailRent.count)")
    }

    
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("contract")
        self.tableview.delegate = self
        self.tableview.dataSource = self
        if let proper = keychainWrapper.string(forKey: "PropertiesID") {
            let str = String(proper)
            self.fetchnRecod(endpoint: str!)
            print("enter parsing in contr")
        }
        // Do any additional setup after loading the view.
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
        if keychainWrapper.string(forKey: "rent") == "unrented" {

                 return 1
            
            }
            else {
            return detailRent.count

            
            }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstFlatsDetailsCell", for: indexPath) as! FirstFlatsDetailsCell
        
        if keychainWrapper.string(forKey: "rent") == "unrented" {
            cell.EndDateLabel.text = " غير موجر"
            cell.EndDateLabel.textAlignment = .center
            cell.EndDateLabel.font = UIFont.boldSystemFont(ofSize: 20)
            cell.ContractButton.isHidden = true
            cell.RenterNameLabel.isHidden = true
            cell.startDateLabel.isHidden = true
            cell.TypeLabel.isHidden = true
            cell.ValueLabel.isHidden = true
        
        }else{
        
            let current_rent = self.detailRent[indexPath.row]
            cell.RenterNameLabel.text = "الموجر: \(current_rent.renter_name!)"
            cell.startDateLabel.text = "تاريخ بداية الايجار: \(current_rent.start_date!)"
            cell.EndDateLabel.text = "تاريخ نهاية الايجار: \(current_rent.end_date!)"
            cell.TypeLabel.text = "نوع الايجار: \(current_rent.type!)"
            cell.ValueLabel.text = "قيمة الايجار: \(current_rent.value!)"
            
            if cell.buttonDelegate == nil {
                cell.tag = indexPath.row
                cell.buttonDelegate = self
            }
            
            
            if let photos = self.detailRent[indexPath.row].photos {
                if (photos.count)<=0{
                    cell.ContractButton.isHidden = true
                }else{
                    cell.ContractButton.isHidden = false

                    //open photo browser
                }
            }else{
                cell.ContractButton.isHidden = true
                
            }

        }
        
        
        
        return cell

        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 263
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
