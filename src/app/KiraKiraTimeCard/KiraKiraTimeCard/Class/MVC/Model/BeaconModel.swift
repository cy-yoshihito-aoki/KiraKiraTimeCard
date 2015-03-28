//
//  BeaconModel.swift
//  KiraKiraTimeCard
//
//  Created by saimushi on 2015/03/26.
//  Copyright (c) 2015年 saimushi. All rights reserved.
//

import Foundation

protocol BeaconModelProtocol :NSObjectProtocol {
    // インターフェースの定義
    func execute(argSuccessInLocationBlock :(() -> ()), argSuccessBeaconBlock :(() -> ()))
}

class BeaconModel :NSObject, BeaconModelProtocol, iBeaconAgentDelegate {
    var ibeacon :iBeaconAgent
    // ビーコンロケーション内に入った時に実行されるブロック
    var successInLocationBlock: (() -> ())
    // ビーコン通信成功時に実行されるブロック
    var successBeaconBlock: (() -> ())

    // コンストラクタ
    override init() {
        // iBeaconAgentを初期化
        ibeacon = iBeaconAgent()
        successInLocationBlock = {
            // デフォルトは何もしない空の実行
            NSLog("イン ロケーション 成功")
        }
        self.successBeaconBlock = {
            // デフォルトは何もしない空の実行
            NSLog("ビーコン通信 成功")
        }
        super.init()
        // ビーコンエージェントのデレゲートを受け取る
        ibeacon.delegate = self
    }

    // デストラクタ
    deinit{
    }

    func execute(argSuccessInLocationBlock :(() -> ()), argSuccessBeaconBlock :(() -> ())) {
        // ブロックの登録
        successInLocationBlock = argSuccessInLocationBlock
        successBeaconBlock = argSuccessBeaconBlock
        // ビーコン監視を開始
        ibeacon.start()
    }

    // ビーコンの近くに入った時のデレゲートメソッド
    func inRangLocation() {
        // ビーコンロケーション内に入った時のブロックを実行
        successInLocationBlock();
    }

    // ビーコンと通信出来た時のデレゲートメソッド
    func inRangBeacon() {
        // ビーコン通信成功時のブロックを実行
        successBeaconBlock();
    }
}
