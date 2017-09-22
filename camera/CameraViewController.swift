//
//  CameraViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/21.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    private var shutterLabel:UILabel!
    private var shutterButton:UIButton!
    
    private var cameraView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景の変更
        self.view.backgroundColor = UIColor.black
        
        // カメラ表示用のViewの用意
        cameraView = UIView()
        cameraView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.width/3 * 4)
        cameraView.backgroundColor = UIColor.white
        self.view.addSubview(cameraView)

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
        
        shutterButton.frame = CGRect(x: Int(shutterLabelPositionX) + difference, y: Int(shutterLabelPositionY) + difference, width: shutterButtonRadius * 2, height: shutterButtonRadius * 2)
        shutterButton.layer.masksToBounds = true
        
        shutterButton.backgroundColor = UIColor.white
        shutterButton.layer.cornerRadius = CGFloat(shutterButtonRadius)
        shutterButton.addTarget(self, action: #selector(CameraViewController.onClickShutterButton(sender:)), for: .touchUpInside)
        
        self.view.addSubview(shutterButton)
    }

    var captureSesssion: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    override func viewWillAppear(_ animated: Bool) {
        captureSesssion = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()
        
        captureSesssion.sessionPreset = AVCaptureSession.Preset.photo // 解像度の設定
        
        let device =  AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        
        do {
            let input = try AVCaptureDeviceInput(device: device!)
            
            // 入力
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                
                // 出力
                if (captureSesssion.canAddOutput(stillImageOutput!)) {
                    captureSesssion.addOutput(stillImageOutput!)
                    captureSesssion.startRunning() // カメラ起動
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
                    previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect // アスペクトフィット
                    previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait // カメラの向き
                    
                    self.cameraView.layer.addSublayer(previewLayer!)
                    
                    // ビューのサイズの調整
                    previewLayer?.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                    previewLayer?.bounds = self.cameraView.frame
                }
            }
        }
        catch {
            print(error)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    internal func onClickShutterButton(sender: UIButton) {
        print("onClickShutterButton:");
    }
}
