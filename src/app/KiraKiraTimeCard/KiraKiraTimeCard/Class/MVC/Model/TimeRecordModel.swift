//
//  TimeRecordModel.swift
//  KiraKiraTimeCard
//
//  Created by saimushi on 2015/03/26.
//  Copyright (c) 2015年 saimushi. All rights reserved.
//

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

    override init () {
        timeRecords = NSMutableDictionary();
        let ud = NSUserDefaults.standardUserDefaults()
        let tmpDic: AnyObject? = ud.objectForKey("timeRecords")
        if (tmpDic != nil){
            timeRecords = tmpDic as NSMutableDictionary
        }
        authorized = false
    }

    func save(argSuccessSaveBlock :(() -> ())) -> Bool {
        authorized = true
        // 1が出勤済み 0が退勤済み キー無しは未出勤
        timeRecords.setObject("hoge", forKey: "1")
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(timeRecords, forKey: "timeRecords")
        // 終了ブロックをコール
        argSuccessSaveBlock()
        return true
    }

    func load() -> NSMutableDictionary {
        return timeRecords
    }
}
