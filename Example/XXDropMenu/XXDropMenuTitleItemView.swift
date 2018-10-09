//
//  XXDropMenuTitleItemView.swift
//  XXDropMenu_Example
//
//  Created by LXF on 2018/10/9.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// XXDropMenuTitleViewProtocol
public class XXDropMenuTitleItemView: UIView,XXDropMenuTitleViewProtocol {
    
    public func setSelect(isSelect: Bool, animation: Bool) {
//        rotateArrow()
        
        if isSelect {
            title_Label.textColor = options.titleItemViewTitleSelectColor
            UIView.animate(withDuration: options.titleItemAnimationDuration, animations: {[weak self] () -> () in
                if let selfie = self {
                    selfie.indicateImageView.transform = selfie.indicateImageView.transform.rotated(by: 180 * CGFloat(Double.pi/180))
                }
            })
            print("select")
        }else{
            print("un select")
            title_Label.textColor = options.titleItemViewTitleColor
            UIView.animate(withDuration: options.titleItemAnimationDuration, animations: {[weak self] () -> () in
                if let selfie = self {
                    selfie.indicateImageView.transform = CGAffineTransform.init(rotationAngle: 0)
                }
            })
        }
    }
    
    
    func rotateArrow() {
        UIView.animate(withDuration: options.titleItemAnimationDuration, animations: {[weak self] () -> () in
            if let selfie = self {
                selfie.indicateImageView.transform = selfie.indicateImageView.transform.rotated(by: 180 * CGFloat(Double.pi/180))
            }
        })
    }
    
    var options:XXDropMenuViewOptionsObject
    
    public init(options:XXDropMenuViewOptionsObject) {
        self.options = options
        super.init(frame:CGRect.zero)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        self.addSubview(title_Label)
        self.addSubview(indicateImageView)
        
        title_Label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        indicateImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(title_Label)
            make.left.equalTo(title_Label.snp.right).offset(options.titleIndicateImageViewInset)
        }
        
        title_Label.textColor = options.titleItemViewTitleColor
        
        indicateImageView.image = options.titleIndicateImage
    }
    
    let title_Label = UILabel.init()
    let indicateImageView = UIImageView.init()
    
}



