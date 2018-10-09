//
//  ViewController.swift
//  XXDropMenu
//
//  Created by 240302832@qq.com on 10/08/2018.
//  Copyright (c) 2018 240302832@qq.com. All rights reserved.
//

import UIKit
import XXDropMenu

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dropMenu = XXDropMenuView.init()
        view.addSubview(dropMenu)
        dropMenu.dataSource = self
        dropMenu.delegate = self
        dropMenu.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController:XXDropMenuViewDataSource{
    
    func dropMenuViewOptionsPara(dropMenuView:XXDropMenuView) -> [XXDropMenuViewOptions] {
        return []
    }
    
    func numberByDropMenuViewTitleItem(dropMenuView: XXDropMenuView) -> Int {
        return 3
    }
    
    func dropMenuView(dropMenuView: XXDropMenuView, titleView index: Int) -> UIView {
        let v = XXDropMenuTitleItemView.init(options: dropMenuView.options)
        v.title_Label.text = "title \(index)"
        return v
    }
    
    func dropMenuView(dropMenuView: XXDropMenuView, colIndex: XXDropMenuViewIndex) -> Int {
        
        let tow = colIndex.count > 1 ? colIndex[1].row : 0
        let thre = colIndex.count > 2 ? colIndex[2].row : 0
        
        let s:(Int,Int,Int) = (colIndex.first?.row ?? 0,tow,thre)
        
        
        switch colIndex.first!.row{
            case 0:
                if colIndex.count == 1 {
                    return 10
                }
            
                switch colIndex[1].row{
                    case 0:
                        if colIndex.count == 2 {
                            return 10
                        }
                        switch colIndex[2].row{
                        case 0:
                            if colIndex.count == 3 {
                                return 10
                            }
                            
                        case 1: if colIndex.count == 3 {
                            return 7
                            }
                        case 2: if colIndex.count == 3 {
                            return 8
                            }
                            
                        default: return 0
                    }
                    
                case 1: if colIndex.count == 2 {
                    return 7
                    }
                case 2: if colIndex.count == 2 {
                    return 8
                    }
                    
                    default: return 0
                }
            
            case 1:
                if colIndex.count == 1 {
                    return 8
                }
        case 2: if colIndex.count == 1 {
            return 50
            }
            
        default:
            return 0
        }
        
        return 0
    }
    
    func dropMenuView(dropMenuView: XXDropMenuView, cellBy tableView: UITableView, colIndex: XXDropMenuViewIndex, indexPath: IndexPath,isExpand:Bool) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "id")
        if isExpand {
            cell.accessoryType = .disclosureIndicator
        }
        cell.textLabel?.text = "title\(colIndex.first!.description) \(colIndex)"
        return cell
    }
}
extension ViewController:XXDropMenuViewDelegate{
    func dropMenuViewAddToParent(dropMenuView: XXDropMenuView, maskView: UIView) {
        self.view.addSubview(maskView)
        maskView.snp.makeConstraints { (make) in
            make.top.equalTo(dropMenuView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    func dropMenuViewAddToParent(dropMenuView: XXDropMenuView, optionsView: XXDropMenuOptionsView) {
        self.view.addSubview(optionsView)
        optionsView.snp.makeConstraints { (make) in
            make.top.equalTo(dropMenuView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    func dropMenuViewDidSelectItem(colIndex: XXDropMenuViewIndex) {
        print("\(colIndex)")
    }
    
    func dropMenuViewCancel() {
        
    }
    
    func dropMenuView() {
        
    }
}

