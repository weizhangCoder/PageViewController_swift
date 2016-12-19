//
//  ViewController.swift
//  ZWPageView
//
//  Created by zhangwei on 16/12/9.
//  Copyright © 2016年 jyall. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        let titles = ["游戏","娱乐","美女","颜值","去玩款手","快手","思密达","去玩款手","快手","思密达"]
        let style = ZWTitleStyle()
        style.isScrollEnable = true
        style.isShowScrollLine = true
        style.scrollLineColor = .red
        
        var childVcs = [UIViewController]()
        
        
        for _ in 0..<titles.count {
            let vc = UIViewController()
//            vc.view.backgroundColor = UIColor.red;
            childVcs.append(vc)
            
        }
        
        
        
        
        
        //pagevie 设置frame
        let pageViewFrame = CGRect(x: 0, y: KNavgationBarH, width: KScreenW, height: KScreenH)
        //设置pagview
        let pageView = ZWPageView(frame: pageViewFrame, titles: titles, childVcs: childVcs, parentVc: self, style: style)
        
        
        view.addSubview(pageView)
    }

  


}

