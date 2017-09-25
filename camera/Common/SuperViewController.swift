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

    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
    }
}
