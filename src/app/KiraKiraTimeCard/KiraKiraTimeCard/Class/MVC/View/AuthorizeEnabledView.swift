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
}

class AuthorizeEnabledView :UIView, AuthorizeEnabledViewProtocol {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // これを実装しないとエラーになる
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /*
    *initを拡張(コンビニエンスイニシャライザ)
    *@param frame: CGRect
    *@param auhorized: Bool 現在のログイン状態フラグ
    */
    convenience required init(frame: CGRect, auhorized: Bool) {
        self.init(frame: frame)
        if (auhorized == true){
            var label :UILabel = UILabel(frame: CGRectMake(0, (frame.height-20)/2.0, frame.width, 20))
            label.textAlignment = NSTextAlignment.Center
            label.text = "AuthorizeEnabledView\nnow authorized"
            addSubview(label)
        }
        else {
            var label :UILabel = UILabel(frame: CGRectMake(0, (frame.height-20)/2.0, frame.width, 20))
            label.textAlignment = NSTextAlignment.Center
            label.text = "AuthorizeEnabledView\nnow unauthorized"
            addSubview(label)
        }
    }
}
