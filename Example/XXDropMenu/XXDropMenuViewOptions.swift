//
//  XXDropMenuViewOptions.swift
//  XXDropMenu_Example
//
//  Created by LXF on 2018/10/8.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public enum XXDropMenuViewOptions {
    
    /// titleView
    case titleHeight(CGFloat)
    case titleMargin(UIEdgeInsets)
    case titleItemViewInset(CGFloat)
    case titleViewBackground(UIColor)
    case titleIndicateImage(UIImage)
    case titleIndicateImageViewInset(CGFloat)
    case titleLineViewBackgroundColor(UIColor)
    case titleLineViewHeight(CGFloat)
    
    ///
    case titleItemViewTitleColor(UIColor)
    case titleItemViewTitleSelectColor(UIColor)
    case titleItemAnimationDuration(TimeInterval)
    case titleItemSwitchAnimationDurationDelay(TimeInterval)
    
    /// optionsView
    case optionsViewBackground(UIColor)
    case optionsMaskViewBackground(UIColor)
    case optionsViewShowAnimationDuration(TimeInterval)
    case optionsViewHideAnimationDuration(TimeInterval)
    
    
    /// UITableViewStyle
    case optionsViewTableViewStyleDefault(UITableViewStyle)
    
    /// cell
    case cellHeight(CGFloat)

}

public class XXDropMenuViewOptionsObject{
    
    public var titleHeight:CGFloat = 44
    public var titleMargin:UIEdgeInsets = UIEdgeInsets.zero
    public var titleItemViewInset:CGFloat = 0
    public var titleIndicateImageViewInset:CGFloat = 5 // indicateImageView
    public var titleIndicateImage:UIImage = UIImage.init() // indicateImageView
    public var titleViewBackground:UIColor = UIColor.gray
    public var titleLineViewBackgroundColor:UIColor = UIColor.lightGray
    public var titleLineViewHeight:CGFloat = 0.5
    
    public var titleItemViewTitleColor:UIColor = UIColor.lightGray
    public var titleItemViewTitleSelectColor:UIColor = UIColor.blue
    public var titleItemAnimationDuration:TimeInterval = 0.3
    public var titleItemSwitchAnimationDurationDelay:TimeInterval = 0.1
    
    public var optionsViewBackground:UIColor = UIColor.init(white: 0.3, alpha: 0.5)
    public var optionsMaskViewBackground:UIColor = UIColor.init(white: 0.3, alpha: 0.5)
    public var optionsViewShowAnimationDuration:TimeInterval = 0.3
    public var optionsViewHideAnimationDuration:TimeInterval = 0.3
    
    public var optionsViewTableViewStyleDefault:UITableViewStyle = UITableViewStyle.plain
    
    
    public var cellHeight:CGFloat = 44

    public init(options:[XXDropMenuViewOptions]){
        
        let bundle = Bundle(for: XXDropMenuView.self)
        let url = bundle.url(forResource: "XXDropMenuView", withExtension: "bundle")
        let imageBundle = Bundle(url: url!)
        
//            let checkMarkImagePath = imageBundle?.path(forResource: "checkmark_icon", ofType: "png")
        let arrowImagePath = imageBundle?.path(forResource: "arrow_down_icon", ofType: "png")
        
        titleIndicateImage = UIImage.init(contentsOfFile: arrowImagePath!)!
        
        for option in options {
            
            switch option{
            case .titleHeight(let v):
                titleHeight = v
            case .cellHeight(let v):
                cellHeight = v
            case .titleMargin(let v):
                titleMargin = v
            case .titleItemViewInset(let v):
                titleItemViewInset = v
            case .titleViewBackground(let v):
                titleViewBackground = v
            case .titleIndicateImageViewInset(let v):
                titleIndicateImageViewInset = v
            case .titleIndicateImage(let v):
                titleIndicateImage = v
            case .optionsViewBackground(let v):
                optionsViewBackground = v
            case .optionsMaskViewBackground(let v):
                optionsMaskViewBackground = v
            case .optionsViewShowAnimationDuration(let v):
                optionsViewShowAnimationDuration = v
            case .optionsViewHideAnimationDuration(let v):
                optionsViewHideAnimationDuration = v
  
            case .optionsViewTableViewStyleDefault(let v):
                optionsViewTableViewStyleDefault = v
            case .titleLineViewBackgroundColor(let v):
                titleLineViewBackgroundColor = v
            case .titleLineViewHeight(let v):
                titleLineViewHeight = v
            case .titleItemViewTitleColor(let v):
                titleItemViewTitleColor = v
            case .titleItemViewTitleSelectColor(let v):
                titleItemViewTitleSelectColor = v
            case .titleItemAnimationDuration(let v):
                titleItemAnimationDuration = v
            case .titleItemSwitchAnimationDurationDelay(let v):
                titleItemSwitchAnimationDurationDelay = v
            }
        }
        
    }

}
