//
//  ClockView.swift
//  KiraKiraTimeCard
//
//  Created by saimushi on 2015/03/26.
//  Copyright (c) 2015年 saimushi. All rights reserved.
//

import UIKit

class ClockView :UIView {
    
    private let secondLayer = CAShapeLayer()
    
    let dateLabel: UILabel = UILabel()
    let secondHandImageView: UIImageView = UIImageView(image: UIImage(named: "handle_sec"))
    let minuteHandImageView: UIImageView = UIImageView(image: UIImage(named: "handle_min"))
    let hourHandImageView: UIImageView   = UIImageView(image: UIImage(named: "handle_hour"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor()
        
        // 背景
        var clockBgImageView: UIImageView = UIImageView(image: UIImage(named: "clock_bg"))
        clockBgImageView.frame = CGRect(x: 0, y: 100, width: self.frame.width, height: self.frame.width)
        addSubview(clockBgImageView)
        
        // 日付けラベル
        dateLabel.backgroundColor = UIColor.clearColor()
        dateLabel.frame     = CGRectMake(self.frame.width - 67,
            clockBgImageView.frame.origin.y + (self.frame.width/2) - 8,
            35, 25)
        dateLabel.font      = (font: UIFont(name: "Zapfino", size: 11))
        dateLabel.textColor = UIColor.blackColor()
        dateLabel.textAlignment = NSTextAlignment.Center
        addSubview(dateLabel)
        
        // 時計針
        secondHandImageView.frame = clockBgImageView.frame
        minuteHandImageView.frame = clockBgImageView.frame
        hourHandImageView.frame   = clockBgImageView.frame
        
        addSubview(secondHandImageView)
        addSubview(minuteHandImageView)
        addSubview(hourHandImageView)
        
        // 針の真ん中
        var centerImageView: UIImageView = UIImageView(image: UIImage(named: "center"))
        centerImageView.frame = clockBgImageView.frame
        centerImageView.backgroundColor = UIColor.clearColor()
        addSubview(centerImageView)
        
        // タイマー（1秒毎）
        (NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"reloadClock", userInfo:nil, repeats:true)).fire()
    }
    
    // これを実装しないとエラーになる
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    * 時計を再描画
    */
    func reloadClock() {
        
        // 現在時刻を取得.
        let myDate: NSDate = NSDate()
        
        // カレンダーを取得.
        let myCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        // 取得するコンポーネントを決める
        let myComponetns = myCalendar.components(NSCalendarUnit.CalendarUnitYear   |
            NSCalendarUnit.CalendarUnitMonth  |
            NSCalendarUnit.CalendarUnitDay    |
            NSCalendarUnit.CalendarUnitHour   |
            NSCalendarUnit.CalendarUnitMinute |
            NSCalendarUnit.CalendarUnitSecond |
            NSCalendarUnit.CalendarUnitWeekday,
            fromDate: myDate)
        
//        let weekdayStrings: Array = ["nil","日","月","火","水","木","金","土","日"]
        
        //        println("year: \(myComponetns.year)")
        //        println("month: \(myComponetns.month)")
        //        println("day: \(myComponetns.day)")
//        println("hour: \(myComponetns.hour)")
//        println("minute: \(myComponetns.minute)")
//        println("second: \(myComponetns.second)")
        //        println("weekday: \(weekdayStrings[myComponetns.weekday])")
        
        var myStr: String = "\(myComponetns.year)年"
        myStr += "\(myComponetns.month)月"
        myStr += "\(myComponetns.day)日"
        //        myStr += "\(weekdayStrings[myComponetns.weekday])]"
        myStr += "\(myComponetns.hour)時"
        myStr += "\(myComponetns.minute)分"
        myStr += "\(myComponetns.second)秒"
        dateLabel.text = "\(myComponetns.day)"

        // radianで回転角度を指定
        let minute: CGFloat = CGFloat(60 * myComponetns.hour + myComponetns.minute)

        let angleSec:CGFloat = 2 * CGFloat(M_PI) * CGFloat(myComponetns.second) / 60.0
        let angleMin:CGFloat = 2 * CGFloat(M_PI) * CGFloat(myComponetns.minute) / 60.0
        let angleHor:CGFloat = 2 * CGFloat(M_PI) * minute/(60 * 12);

        // アニメーションの秒数を設定
        UIView.animateWithDuration(1.0,

            animations: { () -> Void in

                // 回転用のアフィン行列を生成
                self.secondHandImageView.transform = CGAffineTransformMakeRotation(angleSec)
                self.minuteHandImageView.transform = CGAffineTransformMakeRotation(angleMin)
                self.hourHandImageView.transform   = CGAffineTransformMakeRotation(angleHor)
            },
            completion: { (Bool) -> Void in
        })
    }
}
