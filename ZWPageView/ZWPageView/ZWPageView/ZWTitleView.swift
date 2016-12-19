//
//  ZWTitleView.swift
//  ZWPageView
//
//  Created by zhangwei on 16/12/9.
//  Copyright © 2016年 jyall. All rights reserved.
//

import UIKit

protocol ZWTitleViewDelagate: class {
    func titleView(_ titleView:ZWTitleView , targerIndex:Int)
}

class ZWTitleView: UIView {
    
    weak var delegate : ZWTitleViewDelagate?
    
    fileprivate var titles:[String]
    fileprivate var style:ZWTitleStyle!
    fileprivate var currentIndex:Int = 0
    fileprivate lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.scrollsToTop = false
        return scrollView
    }()
    
    fileprivate lazy var bottomLine:UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.scrollLineColor
        bottomLine.frame.size.height =  self.style.scrollLineHeigth
        bottomLine.frame.origin.y = self.bounds.height - self.style.scrollLineHeigth
        return bottomLine
    }()
    fileprivate lazy var titleLables:[UILabel] = [UILabel]()
    init(frame: CGRect,titles:[String],style:ZWTitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ZWTitleView{
    fileprivate func setupUI(){
        
        
    //1.添加scrollView
        addSubview(scrollView)
       
    //2.添加UIlabel
        setupTitleLabels()
    //3 设置frame
        setupTitleLablesFrame()
        
        if style.isShowScrollLine {
            scrollView.addSubview(bottomLine)
        }
    
    }
    // MARK:- 添加按钮
    private func setupTitleLabels(){
        
        for (i,title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: style.fontSize)
            titleLabel.tag = i
            titleLabel.textAlignment  = .center
            titleLabel.textColor = i == 0 ?style.selecColor:style.normalColor
            scrollView.addSubview(titleLabel)
            titleLables.append(titleLabel)
            
            titleLabel.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick))
            titleLabel.addGestureRecognizer(tapGes)
            
            
        }
        
    }
    // MARK:- 设置按钮frame
    private func setupTitleLablesFrame(){
        let h :CGFloat = bounds.height
        let y :CGFloat = 0
        let count : CGFloat = CGFloat(titles.count)
        
        for (i , titlelabel) in titleLables.enumerated() {
            var w :CGFloat = 0
            var x : CGFloat = 0
            
            if style.isScrollEnable {
                //scrollView可以滚动
                w = (titles[i] as NSString).boundingRect(with: CGSize(width:CGFloat(MAXFLOAT),height:0), options: .usesLineFragmentOrigin ,attributes: [NSFontAttributeName:titlelabel.font], context: nil).width
                
                if i == 0 {
                    x = style.itemMargin * 0.5
                    if style.isShowScrollLine {
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }
                    
                }else{
                    let preLabel = titleLables[i - 1]
                    x = preLabel.frame.maxX + style.itemMargin
                
                }
                
            }else{
                //scrollView不可以滚动
                w = bounds.width/count
                x = w * CGFloat(i)
                if i == 0 && style.isShowScrollLine {
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
            
            }
            titlelabel.frame = CGRect(x: x, y: y, width: w, height: h)
            scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLables.last!.frame.maxX + style.itemMargin * 0.5 , height: h):CGSize.zero
            
        }
    
    }

}

// MARK:- 点击监听事件
extension ZWTitleView{
    @objc fileprivate func titleLabelClick(_ tapGes : UIGestureRecognizer){
        
      let label = tapGes.view as! UILabel
        
        if label.tag == currentIndex {
            return
        }
        
        let oldLabel = titleLables[currentIndex]
        
        label.textColor = style.selecColor
        oldLabel.textColor = style.normalColor
        
        currentIndex = label.tag
        
        delegate?.titleView(self, targerIndex: currentIndex)
        
        
        // 6.居中显示
        contentViewDidEndScroll()
        
        //3 改变line位置
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = label.frame.origin.x
                self.bottomLine.frame.size.width = label.frame.size.width
            })
        }
     
        
        
    }
    
    //ZWTiltle 改变标题
    func contentViewDidEndScroll() {
        // 0.如果是不需要滚动,则不需要调整中间位置
        guard style.isScrollEnable else { return }
        
        // 1.获取获取目标的Label
        let targetLabel = titleLables[currentIndex]
        
        // 2.计算和中间位置的偏移量
        var offSetX = targetLabel.center.x - bounds.width * 0.5
        if offSetX < 0 {
            offSetX = 0
        }
        
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offSetX > maxOffset {
            offSetX = maxOffset
        }
        
        // 3.滚动UIScrollView
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
    }
    
}

// MARK:- 暴露给外部的接口去让调用
extension ZWTitleView {


    
    func setTitleWithProgress(sourceIndex: Int, targerIndex: Int,_ progress: CGFloat) {
        //1.取出Label
      
      
        
        let sourceLabel = titleLables[sourceIndex]
        let targetLabel = titleLables[targerIndex]
        //2,颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selecColor, style.normalColor)
        let selectRGB = style.selecColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        
        sourceLabel.textColor  = UIColor(r: selectRGB.0 - deltaRGB.0, g: selectRGB.1 - deltaRGB.1, b: selectRGB.2 - deltaRGB.2)
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        
        //记录最新的
        currentIndex = targerIndex
        //是否展示线
        if style.isShowScrollLine {
            let deltaX = targetLabel.frame.origin.x  - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX  * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
        }
        
        contentViewDidEndScroll()
        
        
    }
    
    
    

}

