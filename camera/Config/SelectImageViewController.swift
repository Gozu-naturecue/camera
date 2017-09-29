//
//  SelectImageViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/28.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import UIKit
import SnapKit

class SelectImageViewController: SuperViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select a Image"
        
        imageView = UIImageView(frame: self.view.bounds)
        
        // インスタンス生成
        imagePicker = UIImagePickerController()
        
        // デリゲート設定
        imagePicker.delegate = self
        
        // 画像の取得先はフォトライブラリ
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        // 画像取得後の編集を不可に
        imagePicker.allowsEditing = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    /**
     画像が選択された時に呼ばれる.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //選択された画像を取得.
        let image: AnyObject?  = info[UIImagePickerControllerOriginalImage]
        //選択された画像を表示するViewControllerを生成.
        let cropImageViewController = CropImageViewController()
        
        //選択された画像を表示するViewContorllerにセットする.
        cropImageViewController.image = image as! UIImage
        
        imagePicker.pushViewController(cropImageViewController, animated: true)
        
    }
    
    /**
     画像選択がキャンセルされた時に呼ばれる.
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // モーダルビューを閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
}
