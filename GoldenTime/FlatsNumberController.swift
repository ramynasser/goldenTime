//
//  FlatsController.swift
//  GoldenTime
//
//  Created by ramy nasser on 6/20/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON
import AlamofireImage
private let reuseIdentifier = "FlatsCell"

class FlatsNumberController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var properties = [Property]()
    var data = [NSData]()
    var leftAndRightPaddings:CGFloat = 6.0
    var numbersOfItemsPerRow:CGFloat = 2.0

    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let proper = keychainWrapper.string(forKey: "PropertiesID") {
        let str = String(proper)
        self.fetchFlats(endpoint: str!)
        print("enter parsing")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(FlatsCell.self, forCellWithReuseIdentifier: "FlatsCell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.invalidateLayout()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth =  UIScreen.main.bounds.width //® collectionView.frame.width
        let itemWidth = (collectionWidth - leftAndRightPaddings) / numbersOfItemsPerRow
        
        return  CGSize(width:  itemWidth, height: 200)
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
                
                imgData = NSData(data: UIImageJPEGRepresentation(image, 0.2)!)
                
                if let data = imgData {
                    print("Size of Image: \(self.data) bytes")
                    UiHelpers.hideLoader()
                    self.loader.stopAnimating()
                    
                    self.data.insert(data, at: 0)
                    self.collectionView?.reloadData()
                    
                }
                else {
                    
                }
                self.collectionView?.reloadData()
            }
        }
        
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchFlats(endpoint:String) {
        print("enter not parsing")
        self.loader.startAnimating()
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
                    print("the count \(postData.count)")
                    print(postData)
                    let childsObject  = postData["childs"].array

                    let childsData = JSON(childsObject)

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
                    var Photo  = [Photos]()
                    var Detail =  [Details]()
                    
                    
                    
                    var Photoid:Int?
                    var PhotoFile:String?
                    //
                    for i in 0..<(childsData.count) {
                        
                        
                        var Photoid:Int?
                        var PhotoFile:String?
                        //
                        let PhotoObject  = childsData[i]["photos"].array
                        
                        let PhotosJson = JSON(PhotoObject)
                        print("count of phot image \(PhotoObject?.count)")
                        if (PhotoObject?.count)! > 0 {
                            if let id = PhotosJson[0]["id"].int ,
                                let filename = PhotosJson[0]["file"].string {
                                Photoid = id
                                PhotoFile = filename
                                var Photo = Photos(id: Photoid!, file: PhotoFile!)
                                let BaseURL = "https://goldenxtime.herokuapp.com/static/"
                                let final = BaseURL.appending((Photo.file))
                                
                                self.retrieveImage(Endpoint: final, headers: headers)
                                print("donnnnnnne")
                            }
                            else {
                                if let img = UIImage(named: "property_image") {
                                    let data = UIImagePNGRepresentation(img) as NSData?
                                    self.data.insert(data!, at: 0)
                                }
                            }
                        }
                        else {
                            if let img = UIImage(named: "property_image") {
                                let data = UIImagePNGRepresentation(img) as NSData?
                                self.data.insert(data!, at: 0)
                            }
                            
                        }
                        
                        for index in 0...PhotosJson.count {
                            if let id = PhotosJson[index]["id"].int ,
                                let filename = PhotosJson[index]["file"].string {
                                Photoid = id
                                PhotoFile = filename
                                Photo.append(Photos(id: Photoid!, file: PhotoFile!))
                                
                                
                                let BaseURL = "https://goldenxtime.herokuapp.com/static/"
                                
                                
                                let final = BaseURL.appending((Photo[0].file))
                                
                                self.retrieveImage(Endpoint: final, headers: headers)
                                print("donnnnnnne")
                            }
                            else {
                                print("no donnnnnnne2")
                                Photoid = 0
                                PhotoFile = "property.jpg"
                                Photo.append(Photos(id: Photoid!, file: PhotoFile!))
                                print("no donnnnnnne")
                                let BaseURL = "https://goldenxtime.herokuapp.com/static/"
                                let final = BaseURL.appending((Photo[0].file))
                                print(final)
                                
                                self.retrieveImage(Endpoint: final, headers: headers)
                                
                                
                                
                            }
                            
                        }
                        
                    if let id = childsData[i]["id"].int  {
                        Id = id
                    }
                    else {
                        Id = 0
                    }
                    if let name = childsData[i]["name"].string  {
                        Name = name
                    }
                    else
                    {
                        Name = ""
                    }
                    if let unit_id = childsData[i]["unit_id"].int {
                        Unit_id = unit_id
                    }
                    else {
                        Unit_id = 0
                    }
                    if let unit_type = childsData[i]["unit_type"].string  {
                        Unit_type = unit_type
                    }
                    else {
                        Unit_type = ""
                    }
                    if let classType = childsData[i]["class"].string  {
                        Class_type = classType
                    }
                    else {
                        Class_type = ""
                        
                    }
                    if let area = childsData[i]["area"].string {
                        
                        Area = area
                    }
                    else {
                        Area = ""
                    }
                    if let address = childsData[i]["address"].string {
                        Address = address
                    }
                    else {
                        Address = ""
                    }
                    if let rented = childsData[i]["rented"].int {
                        Rented = rented
                    }
                    else {
                        Rented = 0
                    }
                    
                    if let rented = childsData[i]["rentable"].int {
                        Rentable = rented
                    }
                    else {
                        Rentable = 0
                    }
                    if let top_level = childsData[i]["top_level"].int {
                        Top_level = top_level
                    }
                    else {
                        Top_level = 0
                    }
                    //  let parent_property_id = postData["parent_property_id"].string
                    if let owner_id = childsData[i]["owner_id"].int {
                        Owner_id = owner_id
                    }
                    else {
                        Owner_id = 0
                    }
                    if let parent_property_id = childsData[i]["parent_property_id"].int
                    {
                        Parent_property_id = parent_property_id
                    }
                    else {
                        Parent_property_id = 0
                    }
                    if let notes = childsData[i]["notes"].string
                    {
                        Notes = notes
                    }
                    else {
                        Notes = ""
                    }
                    
                      
                        
                                            let DetailsObject  = childsData[i]["details"].array
                    let DetailsJson = JSON(DetailsObject)
                    
                    print("count of details \(DetailsJson.count)")
                    
                    for i in 0..<(DetailsJson.count) {
                        
                        if let key = DetailsJson[i]["key"].string,
                            let value = DetailsJson[i]["value"].int
                        {
                            
                            print("fetch data of details ")
                            let d = Details(key: key, value: value)
                            print("key \(key)")

                            Detail.insert(d, at: 0)
                            
//                            let pro = Property(id: Id!, name: Name!, unit_id: Unit_id!, unit_type: Unit_type!, class_type: Class_type!, area: Area!, address: Address!, notes: Notes!, rented: Rented!, rentable: Rented!, top_level: Top_level!, parent_property_id: 1, owner_id: Owner_id!, photos: Photo!, details: Detail)
                            self.collectionView?.reloadData()
                        }
                            
                            
                        else {
                            let d = Details(key: "key", value: 0)
                            Detail.insert(d, at: 0)
                            
                            print("fetch data odassadf details ")
                            
                        }
                        
                        
                    }
                    
                    
                        let pro = Property(id: Id!, name: Name!, unit_id: Unit_id!, unit_type: Unit_type!, class_type: Class_type!, area: Area!, address: Address!, notes: Notes!, rented: Rented!, rentable: Rented!, top_level: Top_level!, parent_property_id: 1, owner_id: Owner_id!, photos: Photo, details: Detail)
                        print("detail count  \(Detail.count)")

                        self.properties.append(pro)
                        Photo = []
                        Detail = []


                    self.collectionView?.reloadData()
                    print("the id \(Id)")
                    
                    // self.tableview.reloadData()
                    
                    
                    
                    // self.tableview.reloadData()
                    
                    
                }
                self.collectionView?.reloadData()
                
                
                
            }
            self.collectionView?.reloadData()
            
        }
        self.collectionView?.reloadData()
        }
        
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return properties.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlatsCell", for: indexPath) as! FlatsCell
        
        let pro = properties[indexPath.row]
//        if indexPath.row != nil {
//            if let imageData =  self.data[indexPath.row]  as? Data{
//                if imageData != nil {
//                    cell.FlatImageView.image =  UIImage(data: imageData )
//                   // cell.FlatImageView.af_setImage(withURL: "")
//                    
//                }
//                else {
//                    cell.FlatImageView.image =  UIImage(named: "property_image")
//                    
//                }
//            }
//        }
        cell.FlatImageView.image =  UIImage(named: "property_image")
        cell.flatNameLabel.text =  pro.name
        
        return cell
        
        
        
        
        // Configure the cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if keychainWrapper.set("floor", forKey: "type") {
            let id =  properties[indexPath.row].id
            let idString = String(id)
            
            if keychainWrapper.set("floor", forKey: "type") && keychainWrapper.set(idString, forKey: "PropertiesID") {
             
                
                if properties[indexPath.row].rented == 1  {
                    if keychainWrapper.set("rented", forKey: "rent"){
                        let view = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
                        let view2 = self.storyboard!.instantiateViewController(withIdentifier: "DetailsOfFLatController")as! DetailsOfFLatController
                        view2.proper = properties[indexPath.row]
                        view.proper = properties[indexPath.row]
                        self.navigationController?.pushViewController(view, animated: true)
                    }
                }else{
                    if keychainWrapper.set("unrented", forKey: "rent"){
                        let view = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
                        let view2 = self.storyboard!.instantiateViewController(withIdentifier: "DetailsOfFLatController")as! DetailsOfFLatController
                        view2.proper = properties[indexPath.row]
                        view.proper = properties[indexPath.row]
                        self.navigationController?.pushViewController(view, animated: true)
                    }
                }
        
           
            }
 }
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
