//
//  ZWPageView.swift
//  ZWPageView
//
//  Created by zhangwei on 16/12/9.
//  Copyright © 2016年 jyall. All rights reserved.
//

import UIKit

class ZWPageView: UIView {
//titles 标题文字  childVcs 控制器 parentVc父视图 style设置属性
    fileprivate var titles : [String]
    fileprivate var childVcs:[UIViewController]
    fileprivate var parentVc:UIViewController
    fileprivate var style:ZWTitleStyle
    
    fileprivate var titleView:ZWTitleView!
    fileprivate var contentView:ZWPageContenView!
    
    init(frame: CGRect,titles:[String],childVcs:[UIViewController],parentVc:UIViewController,style:ZWTitleStyle) {
        
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        super.init(frame:frame)
        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
//MAKE:-创建UI
extension ZWPageView{
    fileprivate func setupUI(){
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeigth)
        titleView = ZWTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y:style.titleHeigth, width: bounds.width, height: bounds.height - style.titleHeigth)
        contentView = ZWPageContenView(frame: contentFrame, childs: childVcs, parent: parentVc)
        contentView.delegate = self
        addSubview(contentView)
       
    }
}



// MARK:-代理 ZWTitleViewDelagate
extension ZWPageView :ZWTitleViewDelagate{
    func titleView(_ titleView: ZWTitleView, targerIndex: Int) {

        contentView.setCurrentIndex(targerIndex)
      
    }

}

// MARK:-代理 ZWPageContenViewDelegate
extension ZWPageView : ZWPageContenViewDelegate{
    
    func contentView(_ contentView: ZWPageContenView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(sourceIndex: sourceIndex, targerIndex: targetIndex, progress)
    }
    
     private func contentViewEndScroll(_ contentView: ZWTitleView) {
        titleView.contentViewDidEndScroll()
    }

}



