//
//  HomeViewController.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit
import Segmentio
import Alamofire
import AlamofireImage
import FSPagerView
class HomeViewController: UIViewController ,FSPagerViewDataSource,FSPagerViewDelegate{
    var imageNames = ["business_men","flat","property_image"]

    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        return self.data.count
        
    }
    
    /// Asks your data source object for the cell that corresponds to the specified item in the pager view.
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if let imageData =  self.data[index]  as? Data{
            if imageData != nil {
                cell.imageView?.image =  UIImage(data: imageData )
                
            }
            else {
                cell.imageView?.image =  UIImage(named: "property_image")
                
            }
        }
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = index.description+index.description
        return cell
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
       // self.pageControl.currentPage = index
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
    @IBOutlet weak var pageControl: FSPageControl!{
        didSet {
            self.pageControl.numberOfPages = self.imageNames.count
            self.pageControl.contentHorizontalAlignment = .right
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    @IBOutlet weak var pagerView:  FSPagerView!
        
        {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = .zero
            
        }
    }
    
   
    

    
    
   

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var buttonshare: UIBarButtonItem!
    var proper:Property?
    var data = [NSData]()

    @IBAction func share(_ sender: AnyObject) {
        let textToShare = "share"
        
        if let myWebsite = NSURL(string: "http://www.google.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            if let presenter = activityVC.popoverPresentationController {
                presenter.sourceView =  sender.view
                presenter.sourceRect = sender.view.bounds
            }
        
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    fileprivate var currentStyle = SegmentioStyle.onlyLabel
    fileprivate var containerViewController: EmbedContainerViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.pagerview.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
////
////        self.pagecontrol.numberOfPages = 0
////        self.pagecontrol.contentHorizontalAlignment = .right
////        self.pagecontrol.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
////        self.pagecontrol.itemSpacing = 6.0  // [6 - 16]
////
////        self.pagecontrol.setStrokeColor(.green, for: .normal)
////        self.pagecontrol.setStrokeColor(.green, for: .selected)
////        self.pagecontrol.setFillColor(.green, for: .selected)
////
        if let Property = proper {
        self.TitleLabel.text = Property.name
            let BaseURL = "https://goldenxtime.herokuapp.com/static/"
            
            if Property.photos.count > 0{
            for index in 0...Property.photos.count-1 {
            let final = BaseURL.appending((Property.photos[index].file))
            if let  token =  keychainWrapper.string(forKey: "accessToken") {
                let headers: HTTPHeaders = [
                    "x-access-Token": "\(token)",
                ]
            retrieveImage(Endpoint: final, headers: headers)
            }
        }
            }
            
        }
//        if let font = UIFont(name: "flat_regular.ttf", size: 34) {
//        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font]
//            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
//        }

    }
    
    
    func retrieveImage(Endpoint:String,headers: HTTPHeaders) {
        UiHelpers.showLoader()
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
                    UiHelpers.hideLoader()

                self.data.append(data)
                self.pagerView.reloadData()
                   /// self.imageView.image = UIImage(data: data as Data)
                    
                }
                else {
                    
                }
            }
        }
        
        
    }
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: EmbedContainerViewController.self) {
            containerViewController = segue.destination as? EmbedContainerViewController
            containerViewController?.style = currentStyle
        }
    }
    
    // MARK: - Actions
    
    @IBAction fileprivate func showMenu(_ sender: UIBarButtonItem) {
        SideMenuViewController.create().showSideMenu(
            viewController: self,
            currentStyle: currentStyle,
            sideMenuDidHide: { [weak self] style in
                self?.dismiss(
                    animated: false,
                    completion: {
                        if self?.currentStyle != style {
                            self?.currentStyle = style
                            self?.containerViewController?.swapViewControllers(style)
                        }
                    }
                )
            }
        )
    }
    
}
