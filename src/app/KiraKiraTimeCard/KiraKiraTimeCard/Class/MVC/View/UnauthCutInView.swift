//
//  UnauthCutInView.swift
//  KiraKiraTimeCard
//
//  ログアウト(退勤)した時のView
//  
//  Created by saimushi on 2015/03/26.
//  Copyright (c) 2015年 saimushi. All rights reserved.
//

import UIKit

class UnauthCutInView :AuthViewBase {

    var label :UILabel
    var fulltext :String
    var idx :Int
    
    override init(frame: CGRect) {
        label = UILabel(frame: CGRectMake(0, (frame.height-100)/2.0, frame.width, 100))
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Zapfino", size: 16)
        label.textColor = UIColor.greenColor()
        label.text = ""
        fulltext = "Now Sign Out My Company."
        idx = 0
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        alpha = 0
        addSubview(label)
    }
    
    // これを実装しないとエラーになる
    required init(coder aDecoder: NSCoder) {
        label = UILabel(frame: CGRectMake(0, 0, 300, 100))
        fulltext = ""
        idx = 0
        super.init(coder: aDecoder)
    }
    
    override func animatShow(){
        animatShowTypography()
    }
    
    func animatShowTypography(){
        if (idx < fulltext.utf16Count){
            var nowText :String = label.text!
            var subText :String = (fulltext as NSString).substringWithRange(NSRange(location: idx, length: 1))
            idx++
            UIView .animateWithDuration(0.02, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.label.text = ((nowText + subText) as NSString)
                self.alpha += 0.02
            }, completion: { (Bool) -> Void in
                // 再帰的に呼ぶ
                self.animatShowTypography()
            })
        }
        else {
            UIView .animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.label.alpha = 1.0
            }, completion: { (Bool) -> Void in
                self.animatFadeOut()
            })
        }
    }
    
    func animatFadeOut(){
        UIView .animateWithDuration(1.0, delay: 5.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.alpha = 0
        }, completion: { (Bool) -> Void in
            self.removeFromSuperview()
        })
    }
}
