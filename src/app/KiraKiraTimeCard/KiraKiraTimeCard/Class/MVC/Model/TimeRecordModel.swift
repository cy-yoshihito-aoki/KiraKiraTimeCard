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
    func save() -> Bool
    func load() -> NSMutableArray
}

class TimeRecordModel :NSObject, TimeRecordModelProtocol {

    func save() -> Bool {
        return true
    }

    func load() -> NSMutableArray {
        var timeRecords :NSMutableArray = NSMutableArray()
        return timeRecords
    }
}
