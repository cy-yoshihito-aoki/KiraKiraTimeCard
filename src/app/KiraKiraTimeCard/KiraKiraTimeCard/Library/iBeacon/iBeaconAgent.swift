//
//  iBeaconAgent.swift
//  KiraKiraTimeCard
//
//  Created by saimushi on 2015/03/26.
//  Copyright (c) 2015年 saimushi. All rights reserved.
//

import Foundation
import CoreLocation

protocol iBeaconAgentProtocol:NSObjectProtocol {
    // インターフェースの定義
    func start()
    func stop()
}


class iBeaconAgent:NSObject, iBeaconAgentProtocol, CLLocationManagerDelegate {

    var trackLocationManager : CLLocationManager!
    var beaconRegion : CLBeaconRegion!

    // コンストラクタ
    override init() {
        super.init()
        // ロケーションマネージャを作成する
        self.trackLocationManager = CLLocationManager();
        
        // デリゲートを自身に設定
        self.trackLocationManager.delegate = self;
        
        // BeaconのUUIDを設定
        let uuid:NSUUID? = NSUUID(UUIDString: "00000000-7FCB-1001-B000-001C4D74F931")
        
        //Beacon領域を作成
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "net.noumenon-th")
    }

    // デストラクタ
    deinit{
    }

    // ビーコンエージェントによる監視を開始
    func start() {
        //
        // セキュリティ認証のステータスを取得
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示
        if(status == CLAuthorizationStatus.NotDetermined) {
            
            self.trackLocationManager.requestAlwaysAuthorization();
        }
    }

    // ビーコンエージェントを停止
    func stop() {
        //
    }
}
