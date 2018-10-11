//
//  XXDropMenuView.swift
//  XXDropMenu_Example
//
//  Created by LXF on 2018/10/8.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

// MARK: -
// MARK: - item
public protocol XXDropMenuTitleViewProtocol:class {
    func setSelect(isSelect:Bool,animation:Bool)
}

public typealias XXDropMenuViewIndex = [IndexPath]

// MARK: -
// MARK: - protocol
public protocol XXDropMenuViewDataSource:class {
    
    func dropMenuViewOptionsPara(dropMenuView:XXDropMenuView)->[XXDropMenuViewOptions]
    
    /// title number
    func numberByDropMenuViewTitleItem(dropMenuView:XXDropMenuView)->Int
    /// titleView by index
    func dropMenuView(dropMenuView:XXDropMenuView,titleView index:Int)->UIView
    /// colIndex 的 number
    func dropMenuView(dropMenuView:XXDropMenuView,colIndex:XXDropMenuViewIndex)->Int
    
    func dropMenuView(tableViewStyle dropMenuView:XXDropMenuView,colIndex:XXDropMenuViewIndex)->UITableViewStyle
    /// 返回 cell
    func dropMenuView(dropMenuView:XXDropMenuView,cellBy tableView:UITableView, colIndex:XXDropMenuViewIndex, isExpand:Bool)->UITableViewCell
}

public extension XXDropMenuViewDataSource{
    public func dropMenuView(tableViewStyle dropMenuView: XXDropMenuView, colIndex: XXDropMenuViewIndex) -> UITableViewStyle {
        return dropMenuView.options.optionsViewTableViewStyleDefault
    }
}

public protocol XXDropMenuViewDelegate:class {
    func dropMenuViewAddToParent(dropMenuView:XXDropMenuView,maskView:UIView)
    func dropMenuViewAddToParent(dropMenuView:XXDropMenuView,optionsView:XXDropMenuOptionsView)
    
    /// 根据 isExpand 返回 是否展开  true 默认依据 isExpand
    func dropMenuView(willExpand dropMenuView:XXDropMenuView,colIndex:XXDropMenuViewIndex,isExpand:Bool)->Bool
    
    func dropMenuViewDidSelectItem(dropMenuView:XXDropMenuView,colIndex:XXDropMenuViewIndex)
    
    func dropMenuViewCancel(dropMenuView:XXDropMenuView)
}

public extension XXDropMenuViewDelegate{
    public func dropMenuView(willExpand dropMenuView:XXDropMenuView,colIndex:XXDropMenuViewIndex,isExpand:Bool)->Bool{
        return isExpand ? true : false
    }
}


open class XXDropMenuView: UIView {
    
    public weak var dataSource:XXDropMenuViewDataSource!
    public weak var delegate:XXDropMenuViewDelegate?
    
    public var optionsPara:[XXDropMenuViewOptions]{
        return dataSource.dropMenuViewOptionsPara(dropMenuView: self)
    }
    var _options:XXDropMenuViewOptionsObject?
    public var options:XXDropMenuViewOptionsObject{
        get{
            if let op = _options {
                return op
            }
            _options = XXDropMenuViewOptionsObject.init(options:optionsPara)
            return _options!
        }
        set{
            _options = newValue
        }
    }
    
    // MARK: -
    // MARK: - select item list
    var titleViewList:[Int:UIView] = [:]
    var selectTitleItemIndex:Int?
    
    public func getTitleView<T>(index:Int)->T?{
        return titleViewList[index] as? T
    }
    
    let lineView = UIView.init()
    
    public init() {
        super.init(frame: CGRect.zero)
        
        DispatchQueue.main.async {
            self.initUI()
            self.reload()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        DispatchQueue.main.async {
            self.initUI()
            self.reload()
        }
    }
    
    fileprivate func initUI(){
        addSubview(lineView)
        lineView.backgroundColor = options.titleLineViewBackgroundColor
        lineView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(options.titleLineViewHeight)
        }
    }
    
    ///
    public func reload(){
        
        _options = nil
        selectTitleItemIndex  = nil
        
        self.backgroundColor = options.titleViewBackground
        dropMenuOptionsMaskView.backgroundColor = options.optionsMaskViewBackground
        clearMakeMenu()
    }
    
    
    
    func clearMakeMenu(){
        let number = dataSource.numberByDropMenuViewTitleItem(dropMenuView: self)
        
        guard number > 0 else{
            return
        }
        
        var lastV:UIView?
        
        let v = dataSource.dropMenuView(dropMenuView: self, titleView: 0)
        titleViewList[0] = v
        self.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(options.titleMargin.top)
            make.bottom.equalToSuperview().offset(options.titleMargin.bottom)
            make.left.equalToSuperview().offset(options.titleMargin.left)
        }
        lastV = v
        
        for index in 1..<number {
            let v = dataSource.dropMenuView(dropMenuView: self, titleView: index)
            titleViewList[index] = v
            self.addSubview(v)
            v.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(options.titleMargin.top)
                make.bottom.equalToSuperview().offset(options.titleMargin.bottom)
                make.left.equalTo(lastV!.snp.right).offset(options.titleItemViewInset)
                make.width.equalTo(lastV!)
            }
            lastV = v
        }
        
        lastV!.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(options.titleMargin.right)
        }
        
        titleViewList.forEach { (item) in
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(titleTapAction(tap:)))
            item.value.addGestureRecognizer(tap)
        }
    }
    
    
    
    @objc func titleTapAction(tap:UITapGestureRecognizer){
        
        guard let tapItem = titleViewList.filter({ $0.value == tap.view}).first  else {
            return
        }
        
        if let index = selectTitleItemIndex {
            if index == tapItem.key{
                
                hide()
            }else{
                // 切换选择
                
                hover(fromIndex: index, toIndex: tapItem.key)
            }
            return
        }

        hover(toIndex: tapItem.key)
    }
    
    
    
    
    let dropMenuOptionsView = XXDropMenuOptionsView.init()
    let dropMenuOptionsMaskView = UIView.init()
    
    /// hide
    open func hide(){
        
        // 取消选择
        if let selectTitleItemIndex = selectTitleItemIndex, let titleP = titleViewList[selectTitleItemIndex] as? XXDropMenuTitleViewProtocol {
            titleP.setSelect(isSelect: false, animation: true)
        }
        
        selectTitleItemIndex = nil
        
        hideAnima()
    }
    
    /// hover
    open func hover(fromIndex:Int? = nil,toIndex:Int){
        
        let needAnimation = fromIndex == nil
        
        selectTitleItemIndex = toIndex
        
        delegate?.dropMenuViewAddToParent(dropMenuView: self, maskView: dropMenuOptionsMaskView)
        delegate?.dropMenuViewAddToParent(dropMenuView: self, optionsView: dropMenuOptionsView)
        dropMenuOptionsView.dropMenuView = self
        dropMenuOptionsView.initUI()
        
        
        if needAnimation {
            hoverAnima()
        }
        
        if let fromIndex = fromIndex,let titleP = titleViewList[fromIndex] as? XXDropMenuTitleViewProtocol {
            titleP.setSelect(isSelect: false, animation: true)
        }

        if let titleP = titleViewList[toIndex] as? XXDropMenuTitleViewProtocol {
            titleP.setSelect(isSelect: true, animation: true)
        }
    }
    
    fileprivate func hideAnima(){
        UIView.animate(
            withDuration: options.optionsViewHideAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.dropMenuOptionsMaskView.alpha = 0
                self.dropMenuOptionsView.alpha = 0
        },
            completion: nil
        )
    }
    
    fileprivate func hoverAnima(){
        
        self.dropMenuOptionsMaskView.alpha = 0
        self.dropMenuOptionsView.alpha = 0
        
        UIView.animate(
            withDuration: options.optionsViewShowAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.dropMenuOptionsMaskView.alpha = 1
                self.dropMenuOptionsView.alpha = 1
        },
            completion: nil
        )
    }
}



