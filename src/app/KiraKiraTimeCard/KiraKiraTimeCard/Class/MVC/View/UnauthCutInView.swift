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

    var bgView :UIView
    var label :UILabel
    var fulltext :String
    var idx :Int
    
    override init(frame: CGRect) {
        label = UILabel(frame: CGRectMake(0, (frame.height-100)/2.0, frame.width, 100))
        bgView = UIView(frame: CGRectMake(0, label.frame.origin.y - 10, 0, 120))
        
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Zapfino", size: 18)
        label.textColor = UIColor(red: 0.0, green: 0.0, blue: 5.0, alpha: 1.0)
        label.text = ""
        fulltext = "Now Sign Out My Company."
        idx = 0
        
        bgView.backgroundColor = UIColor.whiteColor()
        
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        alpha = 0
        
        addSubview(bgView)
        addSubview(label)
    }
    
    // これを実装しないとエラーになる
    required init(coder aDecoder: NSCoder) {
        label = UILabel(frame: CGRectMake(0, 0, 300, 100))
        bgView = UILabel(frame: CGRectMake(0, 0, 300, 100))
        fulltext = ""
        idx = 0
        super.init(coder: aDecoder)
    }
    
    override func animatShow(){
        animatShowTypography()
        UIView .animateWithDuration(0.02, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.bgView.frame = CGRectMake(self.bgView.frame.origin.x, self.bgView.frame.origin.y, self.frame.width, self.bgView.frame.height)
            }, completion: { (Bool) -> Void in
                // 何もしない
            }
        )
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
                self.alpha = 0.8
                }, completion: { (Bool) -> Void in
                    self.animatFadeOut()
            })
        }
    }
    
    func animatFadeOut(){
        UIView .animateWithDuration(1.0, delay: 5.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.bgView.frame = CGRectMake(self.frame.width, self.bgView.frame.origin.y, 0, self.bgView.frame.height)
            self.alpha = 0
            }, completion: { (Bool) -> Void in
                self.bgView.frame = CGRectMake(0, self.bgView.frame.origin.y, self.frame.width, self.bgView.frame.height)
                self.removeFromSuperview()
                self.alpha = 0
        })
    }
}
