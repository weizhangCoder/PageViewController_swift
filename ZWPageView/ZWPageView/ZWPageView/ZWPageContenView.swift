//
//  ZWPageContenView.swift
//  ZWPageView
//
//  Created by zhangwei on 16/12/9.
//  Copyright © 2016年 jyall. All rights reserved.
//

import UIKit

private let  KContenCellID = "KContenCellID"

//这里有点不懂
@objc protocol ZWPageContenViewDelegate : class {
    func contentView(_ contentView : ZWPageContenView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
    
    @objc optional func contentViewEndScroll(_ contentView : ZWPageContenView)
}

class ZWPageContenView: UIView {
    
    weak var delegate : ZWPageContenViewDelegate?
    
    fileprivate var childVcs : [UIViewController]
    fileprivate var parent : UIViewController
    fileprivate var isForbidScrollDelegate : Bool = false
    fileprivate var startOffsetX : CGFloat = 0

    fileprivate lazy var contentionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop  = false
        collectionView.bounces = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: KContenCellID)
        
        return collectionView
    }()

    init(frame: CGRect,childs:[UIViewController],parent:UIViewController) {
        self.childVcs = childs
        self.parent = parent
        super.init(frame: frame)
        
        setupContentUI()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 暴露在外面的方法
extension ZWPageContenView{
    func setCurrentIndex(_ currentIndex : Int)  {
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * contentionView.frame.width
        
        contentionView.setContentOffset(CGPoint(x:offsetX,y:0), animated: false)
    }
}


extension ZWPageContenView{

    fileprivate func setupContentUI(){
        
        for childVc in childVcs {
        childVc.view.backgroundColor = UIColor(r:CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255))
                    )

            parent.addChildViewController(childVc)
        }
        addSubview(self.contentionView)
        
    
    }

}

extension ZWPageContenView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KContenCellID, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

// MARK:- 设置UICollectionView的代理
extension ZWPageContenView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0.判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
           
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            
           
            
        }
        
        // 3.将progress/sourceIndex/targetIndex传递给titleView
        delegate?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
     delegate?.contentViewEndScroll?(self)
        scrollView.isScrollEnabled = true;
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.contentViewEndScroll?(self)
        }else{
            scrollView.isScrollEnabled = false
        }
    }
}


