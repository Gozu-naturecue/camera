//
//  SuperViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/26.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class SuperViewController: UIViewController, AVAudioPlayerDelegate {
    let userDefaults = UserDefaults.standard
    var audioPlayer : AVAudioPlayer!
    var soundName: String = ""
    var shutterImageName: String = ""

    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        self.setDefault(key: "シャッター音", value: "デフォルト")
        self.setDefault(key: "シャッター画面", value: "黒画面")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.soundName = userDefaults.string(forKey: "シャッター音")!
        self.shutterImageName = userDefaults.string(forKey: "シャッター画面")!
    }
    
    /*
     * 音源再生
     */
    func playSound(soundName: String) {
        if soundName == "デフォルト" {
            AudioServicesPlaySystemSound(1108)
        } else {
            //再生する音源のURLを生成.
            let soundFilePath : String = Bundle.main.path(forResource: soundName, ofType: "mp3")!
            let fileURL = URL(fileURLWithPath: soundFilePath)
            //AVAudioPlayerのインスタンス化.
            audioPlayer = try! AVAudioPlayer(contentsOf: fileURL)
            //AVAudioPlayerのデリゲートをセット.
            audioPlayer.delegate = self
            audioPlayer.currentTime = 0
            audioPlayer.play()
        }
    }
    
    //音楽再生が成功した時に呼ばれるメソッド.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if !flag { return }
    }
    
    //デコード中にエラーが起きた時に呼ばれるメソッド.
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("Error")
            print(e.localizedDescription)
            return
        }
    }

    /*
     * ユーザーデフォルト
     */
    // デフォルト値のセット
    func setDefault(key: String, value: String){
        if ((self.userDefaults.string(forKey: key)) == nil) {
            self.userDefaults.set(value, forKey: key)
        }
    }

}
