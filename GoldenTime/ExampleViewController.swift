//
//  ExampleViewController.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit
import Segmentio

class ExampleViewController: UIViewController {
    
    var segmentioStyle = SegmentioStyle.onlyLabel
    
    @IBOutlet fileprivate weak var segmentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var segmentioView: Segmentio!
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    fileprivate lazy var viewControllers: [UIViewController] = {
        return self.preparedViewControllers()
    }()
    
    // MARK: - Init
    
    class func create() -> ExampleViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        return board.instantiateViewController(withIdentifier: String(describing: self)) as! ExampleViewController
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch segmentioStyle {
        case .onlyLabel, .imageBeforeLabel, .imageAfterLabel:
            segmentViewHeightConstraint.constant = 35
        case .onlyImage:
            segmentViewHeightConstraint.constant = 100
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupScrollView()
        
        SegmentioBuilder.buildSegmentioView(
            segmentioView: segmentioView,
            segmentioStyle: segmentioStyle
        )
       // SegmentioBuilder.setupBadgeCountForIndex(segmentioView, index: 1)
        
        segmentioView.selectedSegmentioIndex = selectedSegmentioIndex()
        
        segmentioView.valueDidChange = { [weak self] _, segmentIndex in
            if let scrollViewWidth = self?.scrollView.frame.width {
                let contentOffsetX = scrollViewWidth * CGFloat(segmentIndex)
                self?.scrollView.setContentOffset(
                    CGPoint(x: contentOffsetX, y: 0),
                    animated: true
                )
            }
        }
    }
    
    // Example viewControllers
    
    fileprivate func preparedViewControllers() -> [UIViewController] {
        
        if  keychainWrapper.string(forKey: "type") == "flat" && keychainWrapper.string(forKey: "rent") == "unrented"{
            
            let FlatsdetailsController = self.storyboard!.instantiateViewController(withIdentifier: "aboutController")as! aboutController
            
            let sitecontroller = self.storyboard!.instantiateViewController(withIdentifier: "FlatsNumberController")as! FlatsNumberController

            let Egarscontroller = self.storyboard!.instantiateViewController(withIdentifier: "RentRecordController")as! RentRecordController


            return [
                FlatsdetailsController,
                sitecontroller,
                Egarscontroller
                
                
            ]
        }
        else if  keychainWrapper.string(forKey: "type") == "flat"  && keychainWrapper.string(forKey: "rent") == "rented"{
            let FlatsdetailsController = self.storyboard!.instantiateViewController(withIdentifier: "aboutController")as! aboutController
            
            let sitecontroller = self.storyboard!.instantiateViewController(withIdentifier: "FlatsNumberController")as! FlatsNumberController
            let Egarscontroller = self.storyboard!.instantiateViewController(withIdentifier: "RentRecordController")as! RentRecordController
            let tahselEgarcontroller = self.storyboard!.instantiateViewController(withIdentifier: "contractController")as! contractController
            
            
            return [
                FlatsdetailsController,
                sitecontroller,
                Egarscontroller,
                tahselEgarcontroller,


            ]
            
            
        }
            
        else if   keychainWrapper.string(forKey: "type") == "floor" && keychainWrapper.string(forKey: "rent") == "unrented"{
            let FlatsdetailsController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsOfFLatController")as! DetailsOfFLatController
            
            let sitecontroller = self.storyboard!.instantiateViewController(withIdentifier: "contractController")as! contractController
            
            
            return [
                FlatsdetailsController,
                sitecontroller,
                
                
            ]
        }
        else {
            let FlatsdetailsController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsOfFLatController")as! DetailsOfFLatController
            
            let sitecontroller = self.storyboard!.instantiateViewController(withIdentifier: "contractController")as! contractController
            let rentRecordController = self.storyboard!.instantiateViewController(withIdentifier: "RentRecordController")as! RentRecordController

            return [
                FlatsdetailsController,
                sitecontroller,
                rentRecordController
                
            ]
            
        }
        
        
    }
    
    fileprivate func selectedSegmentioIndex() -> Int {
        return 0
    }
    
    // MARK: - Setup container view
    
    fileprivate func setupScrollView() {
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(viewControllers.count),
            height: containerView.frame.height
        )
        
        for (index, viewController) in viewControllers.enumerated() {
            viewController.view.frame = CGRect(
                x: UIScreen.main.bounds.width * CGFloat(index),
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height
            )
            addChildViewController(viewController)
            scrollView.addSubview(viewController.view, options: .useAutoresize) // module's extension
            viewController.didMove(toParentViewController: self)
        }
    }
    
    // MARK: - Actions
    
    fileprivate func goToControllerAtIndex(_ index: Int) {
        segmentioView.selectedSegmentioIndex = index
    }

}

extension ExampleViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        segmentioView.selectedSegmentioIndex = Int(currentPage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
    }
    
}
