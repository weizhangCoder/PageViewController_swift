//
//  UIColor-Extension.swift
//  ZWPageView
//
//  Created by zhangwei on 16/12/13.
//  Copyright © 2016年 jyall. All rights reserved.
//

import UIKit

extension UIColor{
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1.0) {
       
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    //随机颜色
    class func randimColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g:  CGFloat(arc4random_uniform(256)), b:  CGFloat(arc4random_uniform(256)))
    }
    
    class func getRGBDelta(_ firstColor : UIColor,_ secondColor : UIColor) -> (CGFloat,CGFloat,CGFloat){
        let firstRGB = firstColor.getRGB()
        let secondRGB = secondColor.getRGB()
        return(firstRGB.0 - secondRGB.0,firstRGB.1 - secondRGB.1,firstRGB.2 - secondRGB.2)
       }
    func getRGB() -> (CGFloat,CGFloat,CGFloat) {
        guard let cmps = cgColor.components else {
            fatalError("保证传入正确的RGB值")
        }
        return(cmps[0] * 255,cmps[1] * 255,cmps[2] * 255)
    }
}
