//
//  TestViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/23.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {

    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.centerX.centerY.equalToSuperview()
        })
    }
}
