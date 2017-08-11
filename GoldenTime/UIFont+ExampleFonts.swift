//
//  UIFont+ExampleFonts.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func exampleAvenirMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "JFFlat-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func exampleAvenirLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "JFFlat-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    class func exampleAvenirBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "JFFlat-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
