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
    let secondHandImageView: UIImageView = UIImageView(frame: CGRect(x: 30, y: 30, width: 2, height: 400))
    let minuteHandImageView: UIImageView = UIImageView(frame: CGRect(x: 30, y: 30, width: 2, height: 400))
    let hourHandImageView: UIImageView   = UIImageView(frame: CGRect(x: 30, y: 30, width: 5, height: 400))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var label :UILabel = UILabel(frame: CGRectMake(0, (frame.height-20)/2.0, frame.width, 20))
        label.textAlignment = NSTextAlignment.Center
        label.text = "ClockView"
        addSubview(label)
        
        secondHandImageView.backgroundColor = UIColor.orangeColor();
        minuteHandImageView.backgroundColor = UIColor.yellowColor();
        hourHandImageView.backgroundColor   = UIColor.blueColor();
//        handImageView.backgroundColor   = UIColor.magentaColor();
        secondHandImageView.layer.position = CGPoint(x: self.bounds.width/2, y: 200)
        addSubview(secondHandImageView)
//        addSubview(handImageView)
//        addSubview(minuteHandImageView)
//        addSubview(hourHandImageView)
        
        addSubview(dateLabel)
        
        // 初期化
        secondHandImageView.transform = CGAffineTransformMakeRotation(0)
        minuteHandImageView.transform = CGAffineTransformMakeRotation(0)
        hourHandImageView.transform   = CGAffineTransformMakeRotation(0)
        
        // タイマー（1秒毎）
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"reloadClock", userInfo:nil, repeats:true)
        
//        // 円のレイヤー
//        let frame = view.frame
//        let path = UIBezierPath()
//        path.addArcWithCenter(
//            CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame)),
//            radius: frame.width / 2.0 - 20.0,
//            startAngle: CGFloat(-M_PI_2),
//            endAngle: CGFloat(M_PI + M_PI_2),
//            clockwise: true)
//        secondLayer.path = path.CGPath
//        secondLayer.strokeColor = UIColor.blackColor().CGColor
//        secondLayer.fillColor = UIColor.clearColor().CGColor
//        secondLayer.speed = 0.0
//        view.layer.addSublayer(secondLayer)
//        
//        // 円を描くアニメーション
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = 0.0
//        animation.toValue = 1.0
//        animation.duration = 60.0
//        secondLayer.addAnimation(animation, forKey: "strokeCircle")
//        
//        // CADisplayLink設定
//        let displayLink = CADisplayLink(target: self, selector: Selector("update:"))
//        displayLink.frameInterval = 1   // 1フレームごとに実行
//        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)

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
        
        
        //        // 時、分、秒を取得
        //        NSCalendar *calendar = [NSCalendar currentCalendar];
        //        NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
        //
        //        // 回転角度を計算
        //        NSInteger minute = 60 * dateComps.hour + dateComps.minute;
        //        CGAffineTransform rotateHour = CGAffineTransformMakeRotation( 2 * M_PI * minute / (60 * 12));
        //        CGAffineTransform rotateMin = CGAffineTransformMakeRotation( 2 * M_PI * dateComps.minute / 60);
        //        CGAffineTransform rotateSec = CGAffineTransformMakeRotation( 2 * M_PI * dateComps.second / 60);
        //
        //        // アニメーションをつけて実行
        //        [UIView animateWithDuration:0.1f
        //            animations: ^{
        //            self.hourImageView.transform = rotateHour;
        //            self.minImageView.transform = rotateMin;
        //            self.secImageView.transform = rotateSec;
        //            } ];
        //    }
        //
        

        // radianで回転角度を指定
        let minute: CGFloat = CGFloat(60 * myComponetns.hour + myComponetns.minute)
        
        println("minute: \(minute)")
        
        
        let aa: CGFloat = CGFloat(myComponetns.second / 60)
        let bb: CGFloat = CGFloat(myComponetns.minute / 60)

//        let angleSec:Double = 2 * M_PI * Double(minute / (60 * 12))
//        let angleMin:CGFloat = 2 * CGFloat(M_PI) * CGFloat(myComponetns.minute/60)
//        let angleHor:CGFloat = 2 * CGFloat(M_PI) * CGFloat(myComponetns.second/60)
        
//        let angleSec:CGFloat = 2 * M_PI * dateComps.second / 60
//        let angleMin:CGFloat = 2 * M_PI * dateComps.minute / 60
//        let angleHor:CGFloat = 2 * M_PI * minute / (60 * 12)
        
        
//        // 見本
//        CGAffineTransform rotateSec = CGAffineTransformMakeRotation( 2 * M_PI * dateComps.second / 60);
//        CGAffineTransform rotateMin = CGAffineTransformMakeRotation( 2 * M_PI * dateComps.minute / 60);
//        CGAffineTransform rotateHour = CGAffineTransformMakeRotation( 2 * M_PI * minute / (60 * 12));
        
//        float radian = 45 * M_PI / 180;
  
        let angleSec:CGFloat = 2 * CGFloat(M_PI) * aa
        let angleMin:CGFloat = 2 * CGFloat(M_PI) * CGFloat(myComponetns.minute/60);
        let angleHor:CGFloat = 2 * CGFloat(M_PI) * minute/(60 * 12);
        
        
//        let rotateSec:CGAffineTransform  = CGAffineTransformMakeRotation( 2 * M_PI * myComponetns.second) / 60)
//        let rotateMin:CGAffineTransform  = CGAffineTransformMakeRotation( 2 * M_PI * myComponetns.minute / 60)
//        let rotateHour:CGAffineTransform = CGAffineTransformMakeRotation( 2 * M_PI * minute / (60 * 12))
        
        
        
        
        
//        println("angleHor: \(angleHor)")
//        println("angleMin: \(angleMin)")
//        println("angleSec: \(angleSec)")
        

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
        
        
        
        
        
        let now = NSDate() // 現在日時の取得
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") // ロケールの設定
        dateFormatter.dateFormat = "ss" // 日付フォーマットの設定
        var sec = dateFormatter.stringFromDate(now) // 現在時刻の取得
        
//        // 秒針の設定(詳細を覚える必要は無いです)
//        var angle: Double = Double(sec.toInt()!)    // 数値に変換
//        var mRad = -90 * M_PI / 180;    // ベースの針の長さ
//        var pi:Double = M_PI * 2    // 直径
//        var x = 50 + 50.0 * cos(angle * pi / 60.0 + mRad)   // x座標
//        var y = 50 + 50.0 * sin(angle * pi / 60.0 + mRad)   // y座標
//        var x_float:CGFloat = CGFloat(x)    // 表示用の型に変換
//        var y_float:CGFloat = CGFloat(y)    // 表示用の型に変換
//        
//        // コンテキストを設定
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), false, 0)
//        let context = UIGraphicsGetCurrentContext()
//        
//        // 直線
//        CGContextSetLineWidth(context, 1.0);   // 線の太さ
//        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1) // 線の色(白)
//        CGContextMoveToPoint(context, 50, 50);  // 始点
//        CGContextAddLineToPoint(context, x_float, y_float);  // 終点
//        CGContextStrokePath(context);
//        
//        // 描画した画像をスクリーンショットとして保存
//        let secondHandImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        // 描画
//        // アニメーションの秒数を設定
//        UIView.animateWithDuration(1.0,
//            animations: { () -> Void in
//                // 1秒毎に秒針を更新
//                self.secondHandImageView.image = secondHandImage
//            },
//            completion: { (Bool) -> Void in
//        })
    }
}
