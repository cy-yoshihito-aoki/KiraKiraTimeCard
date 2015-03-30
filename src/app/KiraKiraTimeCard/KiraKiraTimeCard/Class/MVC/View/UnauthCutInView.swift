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

class UnauthCutInView :UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        var label :UILabel = UILabel(frame: CGRectMake(0, (frame.height-20)/2.0 + 40, frame.width, 20))
        label.textAlignment = NSTextAlignment.Center
        label.text = "UnauthCutInView"
        addSubview(label)
    }
    
    // これを実装しないとエラーになる
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
