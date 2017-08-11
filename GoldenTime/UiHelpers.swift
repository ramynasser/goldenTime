//
//  UiHelpers.swift
//  GoldenTime
//
//  Created by ramy nasser on 7/18/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class UiHelpers {
    class func showLoader() {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    class func hideLoader() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    
}
