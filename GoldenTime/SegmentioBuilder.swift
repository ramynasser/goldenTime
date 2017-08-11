//
//  SegmentioBuilder.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko on 11/14/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Segmentio
import UIKit

struct SegmentioBuilder {
    
    static func setupBadgeCountForIndex(_ segmentioView: Segmentio, index: Int) {
        segmentioView.addBadge(
            at: index,
            count: 0,
            color: .clear
        )
    }
    
    static func buildSegmentioView(segmentioView: Segmentio, segmentioStyle: SegmentioStyle) {
        segmentioView.setup(
            content: segmentioContent(),
            style: segmentioStyle,
            options: segmentioOptions(segmentioStyle: segmentioStyle)
        )
    }
    
    private static func segmentioContent() -> [SegmentioItem] {
        
        if  keychainWrapper.string(forKey: "type") == "flat" && keychainWrapper.string(forKey: "rent") == "unrented"{
           
            return [
                SegmentioItem(title: "تفاصيل العقار", image: UIImage(named: "tornado")),
                SegmentioItem(title: "تحتوي علي", image: UIImage(named: "earthquakes")),
                SegmentioItem(title: "تفاصيل الايجار", image: UIImage(named: "earthquakes")),
                
            ]
        }
        else if  keychainWrapper.string(forKey: "type") == "flat"  && keychainWrapper.string(forKey: "rent") == "rented"{
            
            return [
                SegmentioItem(title: "تفاصيل العقار", image: UIImage(named: "tornado")),
                SegmentioItem(title: "تحتوي علي", image: UIImage(named: "earthquakes")),
                SegmentioItem(title: "الايجارات", image: UIImage(named: "earthquakes")),
                SegmentioItem(title: "تفاصيل الايجار", image: UIImage(named: "earthquakes")),
                

                
            ]
            
            
        }
            
        else if   keychainWrapper.string(forKey: "type") == "floor" && keychainWrapper.string(forKey: "rent") == "unrented"{
            
            return [
                SegmentioItem(title: "تفاصيل الشقة", image: UIImage(named: "earthquakes")),
                
                SegmentioItem(title: "تفاصيل الايجار", image: UIImage(named: "tornado")),

                
            ]
        }
        else {
            
            return [
                SegmentioItem(title: "تفاصيل الشقة", image: UIImage(named: "tornado")),
                SegmentioItem(title: "تفاصيل الايجار", image: UIImage(named: "earthquakes")),
                SegmentioItem(title: "الايجارات", image: UIImage(named: "earthquakes")),
                
            ]
            

            
        }
        
    
    }
    
    private static func segmentioOptions(segmentioStyle: SegmentioStyle) -> SegmentioOptions {
        var imageContentMode = UIViewContentMode.center
        switch segmentioStyle {
        case .imageBeforeLabel, .imageAfterLabel:
            imageContentMode = .scaleAspectFit
        default:
            break
        }
        
        
        if  keychainWrapper.string(forKey: "type") == "flat" && keychainWrapper.string(forKey: "rent") == "unrented"{
            return SegmentioOptions(
                backgroundColor: ColorPalette.coral,
                maxVisibleItems: 3,
                scrollEnabled: true,
                indicatorOptions: segmentioIndicatorOptions(),
                horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
                verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
                imageContentMode: imageContentMode,
                labelTextAlignment: .right,
                labelTextNumberOfLines: 1,
                segmentStates: segmentioStates(),
                animationDuration: 0.3
            )
        }
        else if  keychainWrapper.string(forKey: "type") == "flat"  && keychainWrapper.string(forKey: "rent") == "rented"{
            
            return SegmentioOptions(
                backgroundColor: ColorPalette.coral,
                maxVisibleItems: 4,
                scrollEnabled: true,
                indicatorOptions: segmentioIndicatorOptions(),
                horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
                verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
                imageContentMode: imageContentMode,
                labelTextAlignment: .right,
                labelTextNumberOfLines: 1,
                segmentStates: segmentioStates(),
                animationDuration: 0.3
            )
            
            
        }
            
        else if   keychainWrapper.string(forKey: "type") == "floor" && keychainWrapper.string(forKey: "rent") == "unrented"{
            
            return SegmentioOptions(
                backgroundColor: ColorPalette.coral,
                maxVisibleItems: 2,
                scrollEnabled: true,
                indicatorOptions: segmentioIndicatorOptions(),
                horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
                verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
                imageContentMode: imageContentMode,
                labelTextAlignment: .right,
                labelTextNumberOfLines: 1,
                segmentStates: segmentioStates(),
                animationDuration: 0.3
            )        }
        else {
            
            return SegmentioOptions(
                backgroundColor: ColorPalette.coral,
                maxVisibleItems: 3,
                scrollEnabled: true,
                indicatorOptions: segmentioIndicatorOptions(),
                horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
                verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
                imageContentMode: imageContentMode,
                labelTextAlignment: .right,
                labelTextNumberOfLines: 1,
                segmentStates: segmentioStates(),
                animationDuration: 0.3
            )
            
            
        }
        
      
        
    }
    
    private static func segmentioStates() -> SegmentioStates {
        let font = UIFont.exampleAvenirBold(ofSize: 11)
        let selectfont = UIFont.exampleAvenirBold(ofSize: 11)

        return SegmentioStates(
            defaultState: segmentioState(
                backgroundColor: UIColor.clear,
                titleFont: font,
                titleTextColor: ColorPalette.whiteSmoke
            ),
            selectedState: segmentioState(
                backgroundColor: UIColor.clear,
                titleFont: selectfont,
                titleTextColor: UIColor.black
            ),
            highlightedState: segmentioState(
                backgroundColor: UIColor.clear,
                titleFont: font,
                titleTextColor: ColorPalette.whiteSmoke
            )
        )
    }
    
    private static func segmentioState(backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentioState {
        return SegmentioState(
            backgroundColor: backgroundColor,
            titleFont: titleFont,
            titleTextColor: titleTextColor
        )
    }
    
    private static func segmentioIndicatorOptions() -> SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions(
            type: .bottom,
            ratio: 1,
            height: 5,
            color: UIColor.clear
        )
    }
    
    private static func segmentioHorizontalSeparatorOptions() -> SegmentioHorizontalSeparatorOptions {
        return SegmentioHorizontalSeparatorOptions(
            type: .topAndBottom,
            height: 0,
            color: ColorPalette.whiteSmoke
        )
    }
    
    private static func segmentioVerticalSeparatorOptions() -> SegmentioVerticalSeparatorOptions {
        return SegmentioVerticalSeparatorOptions(
            ratio: 0,
            color: ColorPalette.whiteSmoke
        )
    }
    
}
