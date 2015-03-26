# KiraKiraTimeCard
キラキラタイムカード

####OTA
[Adhoc OTA](https://cy-yoshihito-aoki.github.io/KiraKiraTimeCard/ota.html)

####ビーコンについて
ビーコンチェック開始（startMonitoringForRegion）して
開始に成功すると（didStartMonitoringForRegion）が呼ばれ、
開始に失敗すると（monitoringDidFailForRegion）。
 
ビーコンチェック開始に成功したら領域内にいるかどうかの判定（requestStateForRegion）をおこなう。
（didDetermineState）デリゲートが呼ばれる。
 
すでに領域内にいる場合は
（startRangingBeaconsInRegion）で測定（didRangeBeacons）がはじまる。
 
まだ領域内にいない場合は
領域に入ったら（didEnterRegion）が呼ばれ、
（startRangingBeaconsInRegion）で測定（didRangeBeacons）がはじまる。

領域から出たら（didExitRegion）が呼ばれ、
測定をストップする（stopRangingBeaconsInRegion）。
