//
//  MainViewController.swift
//  KiraKiraTimeCard
//
//  Created by saimushi on 2015/03/26.
//  Copyright (c) 2015年 saimushi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var beaconModel :BeaconModel = BeaconModel()
    var timeRecoardModel :TimeRecordModel = TimeRecordModel()
    var authorizeEnabledView :AuthorizeEnabledView?
    var authCutInView :AuthViewBase?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 時計を表示
        view.addSubview(ClockView(frame: view.frame))
    }

    override func viewWillAppear(animated: Bool) {
        if (authorizeEnabledView != nil){
            authorizeEnabledView?.removeFromSuperview()
        }
        if (authCutInView != nil){
            authCutInView?.removeFromSuperview()
        }
        // ビーコン監視実行開始
        beaconModel.execute({ () -> () in
            // ビーコンの近くに来たのでログイン可能画面を表示
            self.authorizeEnabledView = AuthorizeEnabledView(frame: self.view.frame, auhorized: self.timeRecoardModel.authorized)
            self.view.addSubview(self.authorizeEnabledView!)
            self.authorizeEnabledView?.animatShow()
        }, { () -> () in
            if (self.authorizeEnabledView != nil){
                self.authorizeEnabledView?.animatFadeOut()
            }
            // 現在のログイン状態チェック
            if (self.timeRecoardModel.authorized == false) {
                // 未だログイン前
                // ビーコンとの通信に成功したのでログイン完了画面を表示
                self.authCutInView = AuthCutInView(frame: self.view.frame)
                self.view.addSubview(self.authCutInView!)
                self.authCutInView?.animatShow()
            }
            else {
                // ログイン済み
                // ビーコンとの通信に成功したのでログアウト完了画面を表示
                self.authCutInView = UnauthCutInView(frame: self.view.frame)
                self.view.addSubview(self.authCutInView!)
                self.authCutInView?.animatShow()
            }
            // タイムレコード保存
            self.timeRecoardModel.save({ () -> () in
                self.beaconModel.stop()
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
