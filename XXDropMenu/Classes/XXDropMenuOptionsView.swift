//
//  XXDropMenuOptionsView.swift
//  XXDropMenu_Example
//
//  Created by LXF on 2018/10/9.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public class XXUITableView:UITableView{
    var indexPathList:[IndexPath]?
}

public class XXDropMenuOptionsView: UIView {
    
    weak var dropMenuView:XXDropMenuView?
    
    var showTableViewList:[UITableView] = []
    
//    var showTableViewDict:[IndexPath:UITableView] = [:]
    
    
    public init() {
        super.init(frame: CGRect.zero)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    fileprivate func safeGet<T>(list:[T],index:Int)->T?{
        if list.count > index{
            return list[index]
        }
        return nil
    }
    
    fileprivate func addSubColTableView(_ indexPathList: XXDropMenuViewIndex,animation:Bool = false) {
        
        let style = dropMenuView?.dataSource.dropMenuView(tableViewStyle: dropMenuView!, colIndex: indexPathList)
        
        var f = self.frame
        f.origin.x = UIScreen.main.bounds.width
        
        let tv =  XXUITableView.init(frame: f, style: style!)
        
        tv.tableHeaderView = UIView.init(frame: .zero)
        
        
        tv.tableFooterView = UIView.init()
        
        tv.backgroundColor = UIColor.clear
        
        let tvc_temp = showTableViewList
        
        showTableViewList.removeAll()
        
        for i in 0..<tvc_temp.count {
            let tvc = tvc_temp[i] as? XXUITableView
            if indexPathList.count-1 > i{
                if let tvc = tvc{
                    showTableViewList.append(tvc)
                }
            }else{
                
                if animation {
                    UIView.animate(withDuration: 0.3, animations: {
                        tvc?.alpha = 0
                    }) { (res) in
                        tvc?.removeFromSuperview()
                    }
                }else{
                    tvc?.removeFromSuperview()
                }
            }
        }
        
        showTableViewList.append(tv)
        
        tv.indexPathList = indexPathList
        
        self.addSubview(tv)
        tv.dataSource = self
        tv.delegate = self
        
        self.layoutIfNeeded()
    }
    
    func initUI(){
        
        self.backgroundColor = UIColor.clear
        
        showTableViewList.removeAll()
        
        self.subviews.forEach { (v) in
            v.removeFromSuperview()
        }
        
        if let selectTitleItemIndex = dropMenuView?.selectTitleItemIndex {
            addSubColTableView([IndexPath.init(row: selectTitleItemIndex, section: 0)])
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        for index in 0..<showTableViewList.count {
            let v = showTableViewList[index]
            v.frame = makeFrame(index: index)
        }
    }
    
    fileprivate func makeFrame(index:Int)->CGRect{
        let w = frame.width / CGFloat(showTableViewList.count)
        var f = CGRect.init(origin: .zero, size: CGSize.zero)
        
        f.size.width = w
        f.size.height = frame.height
        
        f.origin.x = w * CGFloat(index)
        
        return f
    }
    
    
    fileprivate func index(ofTableView tv:UITableView)->Int?{
        return showTableViewList.firstIndex(of: tv)
    }
    
    
}

extension XXDropMenuOptionsView:UITableViewDelegate{
    
}
extension XXDropMenuOptionsView:UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let indexPathList = (tableView as? XXUITableView)?.indexPathList else{
            return 0
        }
        
        return dropMenuView?.dataSource.dropMenuView(dropMenuView: dropMenuView!, colIndex: indexPathList) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let indexPathList = (tableView as? XXUITableView)?.indexPathList else{
            assertionFailure("越界")
            return UITableViewCell.init()
        }
        
        var t = indexPathList
        
        t.append(indexPath)
        
        let isEx = (dropMenuView?.dataSource.dropMenuView(dropMenuView: dropMenuView!, colIndex: t) ?? 0) > 0
        
        return dropMenuView?.dataSource.dropMenuView(dropMenuView: dropMenuView!, cellBy: tableView, colIndex: indexPathList, indexPath: indexPath,isExpand:isEx) ?? UITableViewCell.init()
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPathList = (tableView as? XXUITableView)?.indexPathList else{
            assertionFailure("越界")
            return
        }
        
        var t = indexPathList
        t.append(indexPath)
        let isEx = (dropMenuView?.dataSource.dropMenuView(dropMenuView: dropMenuView!, colIndex: t) ?? 0) > 0
        
        if dropMenuView?.delegate?.dropMenuView(willExpand: dropMenuView!, colIndex: t, isExpand: isEx) == true{
            self.addSubColTableView(t,animation: true)
        }else{
            dropMenuView?.delegate?.dropMenuViewDidSelectItem(colIndex: t)
            dropMenuView?.hide()
        }
    }
    
}

