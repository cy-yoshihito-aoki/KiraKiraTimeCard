//
//  TimeRecordModel.swift
//  KiraKiraTimeCard
//
//  Created by saimushi on 2015/03/26.
//  Copyright (c) 2015年 saimushi. All rights reserved.
//

import UIkit
import Foundation

protocol TimeRecordModelProtocol :NSObjectProtocol {
    // インターフェースの定義
    var authorized :Bool {get}
    func save(argSuccessSaveBlock :(() -> ())) -> Bool
    func load() -> NSMutableDictionary
}

class TimeRecordModel :NSObject, TimeRecordModelProtocol {
    var authorized :Bool
    var timeRecords :NSMutableDictionary
    var today :NSString

    override init () {
        timeRecords = NSMutableDictionary()
        let ud = NSUserDefaults.standardUserDefaults()
        let tmpDic :AnyObject! = ud.objectForKey("timeRecords")
        // keyとして扱うために日付を文字列にする
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyyMMdd"
        today = dateFormatter.stringFromDate(NSDate())
        println(today)
        authorized = false
        if (tmpDic is NSMutableDictionary){
            // 既にデータが在る場合は、データから出退勤を決める
            timeRecords = tmpDic as NSMutableDictionary
            if (timeRecords.objectForKey(today + "_in") != nil) {
                // 出勤済み
                authorized = true
            }
        }
        println(authorized)
    }

    func save(argSuccessSaveBlock :(() -> ())) -> Bool {
        if (authorized) {
            // 出勤記録が存在するので退勤する
            timeRecords.setObject(NSDate(), forKey: today + "_out")
        } else {
            // まだ出勤記録がないので出勤する
            timeRecords.setObject(NSDate(), forKey: today + "_in")
        }
        // 保存
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(timeRecords, forKey: "timeRecords")
        ud.synchronize()
        // 終了ブロックをコール
        argSuccessSaveBlock()
        
        
        // ID for Vender.
        let myIDforVender = UIDevice.currentDevice().identifierForVendor
        
        println("myIDforVender :\(myIDforVender.UUIDString.utf8)")
        
        // urlを設定
        let urlString:String = "http://46.51.246.185/kkt/timerecord.php?user="
        var request = NSMutableURLRequest(URL: NSURL(string: urlString + myIDforVender.UUIDString)!)
        
        // GETメソッド設定
        request.HTTPMethod = "GET"
        
        // NSURLSessionでHTTP通信
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
            if (error == nil) {
                var result = NSString(data: data, encoding: NSUTF8StringEncoding)!
                println(result)
            } else {
                println(error)
            }
        })
        task.resume()
        
        return true
    }

    func load() -> NSMutableDictionary {
        return timeRecords
    }
}
