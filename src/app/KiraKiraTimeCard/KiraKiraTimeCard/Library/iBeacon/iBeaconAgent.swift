//
//  iBeaconAgent.swift
//  KiraKiraTimeCard
//
//  Created by saimushi on 2015/03/26.
//  Copyright (c) 2015年 saimushi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol iBeaconAgentDelegate: class {
    func inRangLocation()
    func inRangBeacon()
}

protocol iBeaconAgentProtocol:NSObjectProtocol {
    // インターフェースの定義
    func start()
    func stop()
}


class iBeaconAgent:NSObject, iBeaconAgentProtocol, CLLocationManagerDelegate {

    var delegate :iBeaconAgentDelegate?
    var trackLocationManager :CLLocationManager!
    var beaconRegion :CLBeaconRegion!

    // コンストラクタ
    override init() {
        super.init()
        // ロケーションマネージャを作成する
        self.trackLocationManager = CLLocationManager()
        
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
        // デリゲートを自身に設定(この時点でロケーションデレゲートが発生し始めて、監視が開始された事になる)
        self.trackLocationManager.delegate = self;
        // セキュリティ認証のステータスを取得
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示
        if(status == CLAuthorizationStatus.NotDetermined) {
            // 先ずはロケーションマネージャーの使用を許可してもらう
            self.trackLocationManager.requestAlwaysAuthorization()
            return
        }
        // ロケーションマネージャーの使用が許可済みならビーコンの観測をココで開始させる
        trackLocationManager.startMonitoringForRegion(self.beaconRegion)
    }

    // ビーコンエージェントを停止
    func stop() {
        // ロケーションマネージャーからの通知を受け取るのをやめる
        self.trackLocationManager.delegate = nil;
    }

    //位置認証のステータスが変更された時に呼ばれる
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        // 認証のステータス
        var statusStr = "";
        println("CLAuthorizationStatus: \(status)")
        
        // 認証のステータスをチェック
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
//            self.status.text   = "位置情報を許可してないよ"
        case .AuthorizedAlways:
            statusStr = "AuthorizedAlways"
//            self.status.text = "位置情報認証したよ"
        default:
            break;
        }
        
        println(" CLAuthorizationStatus: \(statusStr)")
        
        // ビーコンの観測を開始させる
        trackLocationManager.startMonitoringForRegion(self.beaconRegion)
    }
    
    //観測の開始に成功すると呼ばれる
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        
        println("didStartMonitoringForRegion");
        
        //観測開始に成功したら、領域内にいるかどうかの判定をおこなう。→（didDetermineState）へ
        trackLocationManager.requestStateForRegion(self.beaconRegion);
    }
    
    //領域内にいるかどうかを判定する
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion inRegion: CLRegion!) {
        
        switch (state) {
            
        case .Inside: // すでに領域内にいる場合は（didEnterRegion）は呼ばれない
            
            trackLocationManager.startRangingBeaconsInRegion(beaconRegion);
            // →(didRangeBeacons)で測定をはじめる
            break;
            
        case .Outside:
            
            // 領域外→領域に入った場合はdidEnterRegionが呼ばれる
            break;
            
        case .Unknown:
            
            // 不明→領域に入った場合はdidEnterRegionが呼ばれる
            break;
            
        default:
            
            break;
            
        }
    }

    //領域に入った時
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        // →(didRangeBeacons)で測定をはじめる
        self.trackLocationManager.startRangingBeaconsInRegion(self.beaconRegion)
//        self.status.text = "didEnterRegion"
        // ビーコンと通信可能な領域に入った事を通知
        if (delegate != nil) {
            delegate?.inRangLocation()
        }
        sendLocalNotificationWithMessage("会社についたよ")
    }
    
    //領域から出た時
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        //測定を停止する
        self.trackLocationManager.stopRangingBeaconsInRegion(self.beaconRegion)
//        reset()
        sendLocalNotificationWithMessage("会社からでたよ")
    }
    
    //観測失敗
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("monitoringDidFailForRegion \(error)")
    }
    
    //通信失敗
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError \(error)")
    }
    
    //領域内にいるので測定をする
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: NSArray!, inRegion region: CLBeaconRegion!) {
        //println(beacons)
        
        if(beacons.count == 0) { return }
        //複数あった場合は一番先頭のものを処理する
        var beacon = beacons[0] as CLBeacon
        
        /*
        beaconから取得できるデータ
        proximityUUID   :   regionの識別子
        major           :   識別子１
        minor           :   識別子２
        proximity       :   相対距離
        accuracy        :   精度
        rssi            :   電波強度
        */
        if (beacon.proximity == CLProximity.Unknown) {
//            self.distance.text = "ビーコン見つからないよ"
            reset()
            return
        } else if (beacon.proximity == CLProximity.Immediate) {
//            self.distance.text = "ビーコン近づけすぎ！"
        } else if (beacon.proximity == CLProximity.Near) {
//            self.distance.text = "出勤できるよ"
        } else if (beacon.proximity == CLProximity.Far) {
//            self.distance.text = "ビーコンに近づけて"
        }
//        self.status.text   = "７階についたよ"
//        self.uuid.text     = beacon.proximityUUID.UUIDString
//        self.major.text    = "\(beacon.major)"
//        self.minor.text    = "\(beacon.minor)"
//        self.accuracy.text = "\(beacon.accuracy)"
//        self.rssi.text     = "\(beacon.rssi)"

        // ビーコンと通信成功を通知
        if (delegate != nil) {
            delegate?.inRangBeacon()
        }
    }
    
    func reset(){
//        self.status.text   = "none"
//        self.uuid.text     = "none"
//        self.major.text    = "none"
//        self.minor.text    = "none"
//        self.accuracy.text = "none"
//        self.rssi.text     = "none"
//        self.distance.text = "none"
    }
    
    //ローカル通知
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}
