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
    
    let dateLabel: UILabel = UILabel(frame: CGRectMake(30, 30, 400, 50))
    let secondHandImageView: UIImageView = UIImageView(frame: CGRect(x: 30, y: 30, width: 2, height: 150))
    let minuteHandImageView: UIImageView = UIImageView(frame: CGRect(x: 30, y: 30, width: 2, height: 100))
    let hourHandImageView: UIImageView   = UIImageView(frame: CGRect(x: 30, y: 30, width: 5, height: 50))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var label :UILabel = UILabel(frame: CGRectMake(0, (frame.height-20)/2.0, frame.width, 20))
        label.textAlignment = NSTextAlignment.Center
        label.text = "ClockView"
        addSubview(label)
        
        secondHandImageView.backgroundColor = UIColor.orangeColor();
        minuteHandImageView.backgroundColor = UIColor.yellowColor();
        hourHandImageView.backgroundColor   = UIColor.blueColor();
        
        secondHandImageView.frame = CGRect(x: (self.bounds.width - 2)/2, y: 30, width: 2, height: 300)
        minuteHandImageView.frame = CGRect(x: (self.bounds.width - 2)/2, y: 30, width: 2, height: 200)
        hourHandImageView.frame   = CGRect(x: (self.bounds.width - 5)/2, y: 30, width: 5, height: 100)
        
//        secondHandImageView.layer.position = CGPoint(x: self.bounds.width/2, y: 150)
//        minuteHandImageView.layer.position = CGPoint(x: self.bounds.width/2, y: 100)
//        hourHandImageView.layer.position   = CGPoint(x: self.bounds.width/2, y: 50)
        
        addSubview(secondHandImageView)
        addSubview(minuteHandImageView)
        addSubview(hourHandImageView)
        
        addSubview(dateLabel)
        
//        // 初期化
//        secondHandImageView.transform = CGAffineTransformMakeRotation(0)
//        minuteHandImageView.transform = CGAffineTransformMakeRotation(0)
//        hourHandImageView.transform   = CGAffineTransformMakeRotation(0)
        
        // タイマー（1秒毎）
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"reloadClock", userInfo:nil, repeats:true)
        
        // 円のレイヤー
        let path = UIBezierPath()
        path.addArcWithCenter(
            CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame)),
            radius: frame.width / 2.0 - 20.0,
            startAngle: CGFloat(-M_PI_2),
            endAngle: CGFloat(M_PI + M_PI_2),
            clockwise: true)
        secondLayer.path = path.CGPath
        secondLayer.strokeColor = UIColor.blackColor().CGColor
        secondLayer.fillColor = UIColor.clearColor().CGColor
        secondLayer.speed = 0.0
        layer.addSublayer(secondLayer)
        
        // 円を描くアニメーション
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 60.0
        secondLayer.addAnimation(animation, forKey: "strokeCircle")
        
        // CADisplayLink設定
        let displayLink = CADisplayLink(target: self, selector: Selector("update:"))
        displayLink.frameInterval = 1   // 1フレームごとに実行
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)

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
        dateLabel.text = myStr

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
    
    func update(displayLink: CADisplayLink) {
        // timeOffsetに現在時刻の秒数を設定
        let time = NSDate().timeIntervalSince1970
        let seconds = floor(time) % 60
        let milliseconds = time - floor(time)
        secondLayer.timeOffset = seconds + milliseconds
    }
}
