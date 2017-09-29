//
//  CropImageViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/29.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import Foundation
import UIKit

class CropImageViewController: SuperViewController, UIScrollViewDelegate {
    var image: UIImage!

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        return scrollView
    }()
    var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
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
        view.addSubview(scrollView)
            // scrollViewにimageViewをaddSubview
            setImage()
        view.addSubview(doneButton)
        
        scrollView.snp.makeConstraints({ (make) in
            make.width.height.top.left.equalToSuperview()
        })
        
        imageView.snp.makeConstraints({ (make) in
            make.width.height.equalToSuperview()
            make.top.left.equalTo(0)
        })
        
        doneButton.snp.makeConstraints({ (make) in
            make.width.height.equalTo(70)
            make.bottom.equalTo(0).offset(-25)
            make.centerX.equalToSuperview()
        })

        doneButton.addTarget(self, action: #selector(CropImageViewController.onDownDoneButton(sender:)), for: .touchDown)
        doneButton.addTarget(self, action: #selector(CropImageViewController.onUpDoneButton(sender:)), for: [.touchUpInside,.touchUpOutside])
        
        self.edgesForExtendedLayout = []
        
        self.scrollView.delegate = self
    }

    /**
     選択された画像をUIImageViewにセットする.
     */
    func setImage(){
        self.title = "Selected Image"
        
        imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = image
        self.scrollView.addSubview(imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc internal func onDownDoneButton(sender: UIButton) {
        self.doneButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }

    @objc internal func onUpDoneButton(sender: UIButton) {
        self.doneButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3042594178)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
