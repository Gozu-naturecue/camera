//
//  CropImageViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/29.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func GetImage() -> UIImage{
        
        // キャプチャする範囲を取得.
        let rect = self.bounds
        
        // ビットマップ画像のcontextを作成.
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        // 対象のview内の描画をcontextに複写する.
        self.layer.render(in: context)
        
        // 現在のcontextのビットマップをUIImageとして取得.
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // contextを閉じる.
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
}

extension UIImage {
    func cropping(to: CGRect) -> UIImage? {
        var opaque = false
        if let cgImage = cgImage {
            switch cgImage.alphaInfo {
            case .noneSkipLast, .noneSkipFirst:
                opaque = true
            default:
                break
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(to.size, opaque, scale)
        draw(at: CGPoint(x: -to.origin.x, y: -to.origin.y))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

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
        view.addSubview(scrollView)
            // scrollViewにimageViewをaddSubview
            setImage()
        view.addSubview(doneButton)
        view.addSubview(backButton)
        
        scrollView.snp.makeConstraints({ (make) in
            make.width.height.top.left.equalToSuperview()
        })
        
        imageView.snp.makeConstraints({ (make) in
            make.width.height.equalToSuperview()
            make.top.left.equalTo(0)
        })
        
        backButton.snp.makeConstraints({ (make) in
            make.width.height.equalTo(70)
            make.bottom.equalTo(0).offset(-25)
            make.left.equalToSuperview().offset(25)
        })
        
        doneButton.snp.makeConstraints({ (make) in
            make.width.height.equalTo(70)
            make.bottom.equalTo(0).offset(-25)
            make.right.equalToSuperview().offset(-25)
        })

        backButton.addTarget(self, action: #selector(CropImageViewController.onDownBackButton(sender:)), for: .touchDown)
        backButton.addTarget(self, action: #selector(CropImageViewController.onUpBackButton(sender:)), for: [.touchUpInside,.touchUpOutside])
        doneButton.addTarget(self, action: #selector(CropImageViewController.onDownDoneButton(sender:)), for: .touchDown)
        doneButton.addTarget(self, action: #selector(CropImageViewController.onUpDoneButton(sender:)), for: [.touchUpInside,.touchUpOutside])
        
        self.edgesForExtendedLayout = []
        
        self.scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
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

    @objc internal func onDownBackButton(sender: UIButton) {
        self.doneButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    @objc internal func onUpBackButton(sender: UIButton) {
        self.doneButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3042594178)
        navigationController?.popViewController(animated: true)
    }

    @objc internal func onDownDoneButton(sender: UIButton) {
        self.doneButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }

    @objc internal func onUpDoneButton(sender: UIButton) {
        self.doneButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3042594178)
        
        let capturedImage = imageView.GetImage() as UIImage
        // 相対位置を取得
        let rect = self.view.convert(scrollView.frame, to: imageView)
        let croppedImage = capturedImage.cropping(to: rect )
        
        userDefaults.set(UIImagePNGRepresentation(croppedImage!)! as NSData, forKey: "imageData")
        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
        notificationCenter.post(name: .closeSelectImageViewController, object: nil)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
