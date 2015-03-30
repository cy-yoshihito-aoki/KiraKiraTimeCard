//
//  MainViewController.swift
//  KiraKiraTimeCard
//
//  Created by saimushi on 2015/03/26.
//  Copyright (c) 2015年 saimushi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var beaconModel :BeaconModel?
    var authorizeEnabledView :UIView?
    var authCutInView :UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 時計を表示
        view.addSubview(ClockView(frame: view.frame))
    }

    override func viewDidAppear(animated: Bool) {
        if (authorizeEnabledView != nil){
            authorizeEnabledView?.removeFromSuperview()
        }
        if (authCutInView != nil){
            authCutInView?.removeFromSuperview()
        }
        // 描画完了したらビーコンをスタート
        if (beaconModel == nil){
            beaconModel? = BeaconModel()
        }
        var timeRecoardModel :TimeRecordModel = TimeRecordModel()
        // ビーコン監視実行開始
        beaconModel?.execute({ () -> () in
            // ビーコンの近くに来たのでログイン可能画面を表示
            self.authorizeEnabledView = AuthorizeEnabledView(frame: self.view.frame, auhorized: timeRecoardModel.authorized)
            self.view.addSubview(self.authorizeEnabledView!)
        }, { () -> () in
            // 現在のログイン状態チェック
            if (timeRecoardModel.authorized == false) {
                // 未だログイン前
                // ビーコンとの通信に成功したのでログイン完了画面を表示
                self.authCutInView = AuthCutInView(frame: self.view.frame)
                self.view.addSubview(self.authCutInView!)
            }
            else {
                // ログイン済み
                // ビーコンとの通信に成功したのでログアウト完了画面を表示
                self.authCutInView = UnauthCutInView(frame: self.view.frame)
                self.view.addSubview(self.authCutInView!)
            }
            // タイムレコード保存
            timeRecoardModel.save({ () -> () in
                self.beaconModel!.stop()
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    *ステータスバー非表示
    */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
