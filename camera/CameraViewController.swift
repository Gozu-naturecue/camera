//
//  CameraViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/21.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate {
    
    private var shutterLabel:UILabel!
    private var shutterButton:UIButton!
    
    private var cameraView:UIView!
    
    private var blackView:UIView!
    
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
        shutterButton.addTarget(self, action: #selector(CameraViewController.onDownShutterButton(sender:)), for: .touchDown)
        shutterButton.addTarget(self, action: #selector(CameraViewController.onUpShutterButton(sender:)), for: [.touchUpInside,.touchUpOutside])
        
        self.view.addSubview(shutterButton)
        
        blackView = UIView()
        blackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        blackView.backgroundColor = UIColor.black
        blackView.isHidden = true
        self.view.addSubview(blackView)
    }
    
    @objc internal func onDownShutterButton(sender: UIButton) {
        UIView.animate(withDuration: 0.06,
                       
        // アニメーション中の処理.
        animations: { () -> Void in

            // 縮小用アフィン行列を作成する.
            self.shutterButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                
        })
        { (Bool) -> Void in
            
        }
    }
    
    @objc internal func onUpShutterButton(sender: UIButton) {
        UIView.animate(withDuration: 0.06,
        // アニメーション中の処理.
        animations: { () -> Void in
            
            // 拡大用アフィン行列を作成する.
            self.shutterButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.blackView.isHidden = false
        }, completion: { _ in
            self.blackView.isHidden = true
        })
    }
    
    
    
    var input:AVCaptureDeviceInput!
    var output:AVCaptureVideoDataOutput!
    var session:AVCaptureSession!
    var camera:AVCaptureDevice!
    var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewWillAppear(_ animated: Bool) {
        // カメラの設定
        setupCamera()
    }
    
    // メモリ解放
    override func viewDidDisappear(_ animated: Bool) {
        // camera stop メモリ解放
        session.stopRunning()
        
        for output in session.outputs {
            session.removeOutput(output)
        }
        
        for input in session.inputs {
            session.removeInput(input)
        }
        session = nil
        camera = nil
    }
    
    func setupCamera(){
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        device?.activeVideoMinFrameDuration = CMTimeMake(1, 30)

        do {
            input = try AVCaptureDeviceInput(device: device!)
            session = AVCaptureSession()

            if session.canSetSessionPreset(AVCaptureSession.Preset.photo) {
                session.sessionPreset = AVCaptureSession.Preset.photo
            }
            
            if session.canAddInput(input) {
                session.addInput(input)
            }

            output = AVCaptureVideoDataOutput()
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)]
            output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
            output.alwaysDiscardsLateVideoFrames = true
            
            if session.canAddOutput(output){
                session.addOutput(output)
                session.startRunning()
                
                previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                
                previewLayer?.position = CGPoint(x: self.cameraView.frame.width/2, y: self.cameraView.frame.height/2)
                previewLayer?.bounds = self.cameraView.frame
                self.cameraView.layer.addSublayer(previewLayer!)
            }
        } catch {
            print(error)
        }
    }

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        print("captureOutput")
//        let image = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
//        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }

    func imageFromSampleBuffer(sampleBuffer :CMSampleBuffer) -> UIImage {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!

        // イメージバッファのロック
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))

        // 画像情報を取得
        let base = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)!
        let bytesPerRow = UInt(CVPixelBufferGetBytesPerRow(imageBuffer))
        let width = UInt(CVPixelBufferGetWidth(imageBuffer))
        let height = UInt(CVPixelBufferGetHeight(imageBuffer))

        // ビットマップコンテキスト作成
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerCompornent = 8
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) as UInt32)
        let newContext = CGContext(data: base, width: Int(width), height: Int(height), bitsPerComponent: Int(bitsPerCompornent), bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)! as CGContext

        // 画像作成
        let imageRef = newContext.makeImage()!
        let image = UIImage(cgImage: imageRef, scale: 1.0, orientation: UIImageOrientation.right)

        // イメージバッファのアンロック
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return image
    }

}
