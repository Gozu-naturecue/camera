//
//  SelectImageViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/28.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import UIKit
import SnapKit

class SelectImageViewController: SuperViewController, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "画像を選択"
        
        imageView = UIImageView(frame: self.view.bounds)
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.present(imagePicker, animated: true, completion: nil)
    }

    /**
     画像が選択された時に呼ばれる.
     */
    @objc(imagePickerController:didFinishPickingMediaWithInfo:) func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: AnyObject? = info[UIImagePickerControllerOriginalImage] as AnyObject

        /*
        let cropImageViewController = CropImageViewController()
        cropImageViewController.image = image as! UIImage
        imagePicker.pushViewController(cropImageViewController, animated: true)
         */
    }

    /**
     画像選択がキャンセルされた時に呼ばれる.
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // モーダルビューを閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
}
