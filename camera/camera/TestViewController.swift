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

    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()

    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let modeView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    let shutterLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black
        label.layer.masksToBounds = true
        label.layer.cornerRadius = CGFloat(30)
        // 外枠の設定
        label.layer.borderWidth = 5.0
        label.layer.borderColor = UIColor.white.cgColor
        return label
    }()

    let shutterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = CGFloat(24)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        view.addSubview(headerView)
        view.addSubview(cameraView)
        view.addSubview(modeView)
        view.addSubview(footerView)
        footerView.addSubview(shutterLabel)
        footerView.addSubview(shutterButton)
        
        view.addSubview(blackView)
        
        blackView.snp.makeConstraints({ (make) in
            make.width.height.equalToSuperview()
            make.top.left.equalTo(0)
        })
        headerView.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.left.equalTo(0)
        })
        cameraView.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
            make.height.equalTo(cameraView.snp.width).multipliedBy(1.333)
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalTo(0)
        })
        modeView.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(cameraView.snp.bottom)
            make.left.equalTo(0)
        })
        footerView.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
            make.top.equalTo(modeView.snp.bottom)
            make.left.equalTo(0)
            make.bottom.equalToSuperview()
        })
        shutterLabel.snp.makeConstraints({ (make) in
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        shutterButton.snp.makeConstraints({ (make) in
            make.width.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
        // シャッターボタンの動作
        shutterButton.addTarget(self, action: #selector(CameraViewController.onDownShutterButton(sender:)), for: .touchDown)
        shutterButton.addTarget(self, action: #selector(CameraViewController.onUpShutterButton(sender:)), for: [.touchUpInside,.touchUpOutside])
    }

    @objc internal func onDownShutterButton(sender: UIButton) {
        UIView.animate(withDuration: 0.06,
            animations: { () -> Void in
                self.shutterButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    @objc internal func onUpShutterButton(sender: UIButton) {
        UIView.animate(withDuration: 0.06,
            animations: { () -> Void in
                self.shutterButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.blackView.isHidden = false
        }, completion: { _ in
            self.blackView.isHidden = true
        })
    }

}
