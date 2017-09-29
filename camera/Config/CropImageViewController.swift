//
//  CropImageViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/29.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import Foundation
import UIKit

class CropImageViewController: SuperViewController {

    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = CGFloat(35)
        button.setTitle("BACK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3042594178)
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = CGFloat(35)
        button.setTitle("DONE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3042594178)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(doneButton)
        
        imageView.snp.makeConstraints({ (make) in
            make.width.height.equalToSuperview()
            make.top.left.equalTo(0)
        })
        
        backButton.snp.makeConstraints({ (make) in
            make.width.height.equalTo(70)
            make.bottom.equalTo(0).offset(-25)
            make.left.equalTo(0).offset(25)
        })
        
        doneButton.snp.makeConstraints({ (make) in
            make.width.height.equalTo(70)
            make.bottom.right.equalTo(0).offset(-25)
        })
        
        backButton.addTarget(self, action: #selector(CropImageViewController.onDownBackButton(sender:)), for: .touchDown)
        backButton.addTarget(self, action: #selector(CropImageViewController.onUpBackButton(sender:)), for: [.touchUpInside,.touchUpOutside])
        doneButton.addTarget(self, action: #selector(CropImageViewController.onDownDoneButton(sender:)), for: .touchDown)
        doneButton.addTarget(self, action: #selector(CropImageViewController.onUpDoneButton(sender:)), for: [.touchUpInside,.touchUpOutside])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc internal func onDownBackButton(sender: UIButton) {
        self.backButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    @objc internal func onUpBackButton(sender: UIButton) {
        self.backButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3042594178)
    }
    
    @objc internal func onDownDoneButton(sender: UIButton) {
        self.doneButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }

    @objc internal func onUpDoneButton(sender: UIButton) {
        self.doneButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3042594178)
    }
}
