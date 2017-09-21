//
//  CameraViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/21.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    private var shutterLabel:UILabel!
    private var shutterButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景の変更
        self.view.backgroundColor = UIColor.black
        
        // シャッターの外郭
        shutterLabel = UILabel()
        
        let shutterLabelRadius = 30
        
        let shutterLabelPositionX: CGFloat = self.view.frame.width/2 - CGFloat(shutterLabelRadius)
        let shutterLabelPositionY: CGFloat = self.view.frame.height - CGFloat(shutterLabelRadius) * 2 - 15
        
        shutterLabel.frame = CGRect(x: Int(shutterLabelPositionX), y: Int(shutterLabelPositionY), width: shutterLabelRadius * 2, height: shutterLabelRadius * 2)
        shutterLabel.layer.masksToBounds = true
        
        shutterLabel.backgroundColor = UIColor.black
        shutterLabel.layer.cornerRadius = CGFloat(shutterLabelRadius)
        shutterLabel.layer.borderWidth = 5.0
        shutterLabel.layer.borderColor = UIColor.white.cgColor
        
        self.view.addSubview(shutterLabel)
        
        // シャッターボタン
        shutterButton = UIButton()
        
        let difference = 6
        let shutterButtonRadius = shutterLabelRadius - difference
        
        shutterButton.frame = CGRect(x: difference, y: difference, width: shutterButtonRadius * 2, height: shutterButtonRadius * 2)
        shutterButton.layer.masksToBounds = true
        
        shutterButton.backgroundColor = UIColor.white
        shutterButton.layer.cornerRadius = CGFloat(shutterButtonRadius)
        
        shutterLabel.addSubview(shutterButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
