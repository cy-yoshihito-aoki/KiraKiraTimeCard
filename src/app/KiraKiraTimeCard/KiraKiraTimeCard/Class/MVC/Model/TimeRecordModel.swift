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
    func save() -> Bool
    func load() -> NSMutableArray
}

class TimeRecordModel :NSObject, TimeRecordModelProtocol {
    var authorized :Bool

    override init () {
        authorized = false
    }

    func save() -> Bool {
        authorized = true
        // NSUserDefaultsにタイムレコード保存
        return true
    }

    func load() -> NSMutableArray {
        var timeRecords :NSMutableArray = NSMutableArray()
        // NSUserDefaultsからタイムレコードを抽出して配列にしまう
        return timeRecords
    }
}
