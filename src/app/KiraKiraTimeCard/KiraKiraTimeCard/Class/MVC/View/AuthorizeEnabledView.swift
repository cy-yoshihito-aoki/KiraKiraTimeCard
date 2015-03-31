//
//  AuthorizeEnabledView.swift
//  KiraKiraTimeCard
//
//  ログイン・ログアウト出来る状態になった時のView

//  Created by saimushi on 2015/03/26.
//  Copyright (c) 2015年 saimushi. All rights reserved.
//

import UIKit

protocol AuthorizeEnabledViewProtocol :NSObjectProtocol {
    // インターフェースの定義
    init(frame: CGRect, auhorized: Bool)
    func animatShow()
    func animatFadeOut()
}

class AuthorizeEnabledView :UIView, AuthorizeEnabledViewProtocol {

    var label :UILabel
    var fulltext :String
    var idx :Int

    override init(frame: CGRect) {
        label = UILabel(frame: CGRectMake(0, (frame.height-100)/2.0 + 100, frame.width, 100))
        fulltext = ""
        idx = 0
        super.init(frame: frame)
    }

    // これを実装しないとエラーになる
    required init(coder aDecoder: NSCoder) {
        label = UILabel(frame: CGRectMake(0, 0, 300, 100))
        fulltext = ""
        idx = 0
        super.init(coder: aDecoder)
    }

    /*
    *initを拡張(コンビニエンスイニシャライザ)
    *@param frame: CGRect
    *@param auhorized: Bool 現在のログイン状態フラグ
    */
    convenience required init(frame: CGRect, auhorized: Bool) {
        self.init(frame: frame)
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 4
        label.font = UIFont(name: "Zapfino", size: 14)
        label.text = ""
        label.alpha = 0.1
        fulltext = "Now in the my campany's location."
        if (auhorized == true){
            NSLog("AuthorizeEnabledView 出勤中 退勤出来るよ")
            fulltext += String(" \n Ready to Sign out.")
        }
        else {
            NSLog("AuthorizeEnabledView 退勤中 出勤出来るよ")
            fulltext += String(" \n Ready to Sign in.")
        }
        addSubview(label)
    }

    func animatShow(){
        animatShowTypography()
    }

    func animatShowTypography(){
        if (idx < fulltext.utf16Count){
            var nowText :String = label.text!
            var subText :String = (fulltext as NSString).substringWithRange(NSRange(location: idx, length: 1))
            idx++
            UIView .animateWithDuration(0.02, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.label.text = ((nowText + subText) as NSString)
                self.label.alpha += 0.01
            }, completion: { (Bool) -> Void in
                // 再帰的に呼ぶ
                self.animatShowTypography()
            })
        }
        else {
            animatFlashLabel()
        }
    }

    func animatFlashLabel(){
        UIView .animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            if (self.label.alpha >= 1) {
                self.label.alpha = 0.2
            }
            else {
                self.label.alpha = 1.0
            }
        }, completion: { (Bool) -> Void in
                // 再帰的に呼ぶ
                self.animatFlashLabel()
        })
    }

    func animatFadeOut(){
        UIView .animateWithDuration(1.0, delay: 5.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.alpha = 0
            }, completion: { (Bool) -> Void in
                self.removeFromSuperview()
        })
    }
}
