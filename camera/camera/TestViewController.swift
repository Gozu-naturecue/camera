//
//  TestViewController.swift
//  camera
//
//  Created by nature-cue on 2017/09/23.
//  Copyright © 2017年 nature-cue. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class TestViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var input:AVCaptureDeviceInput!
    var output:AVCaptureVideoDataOutput!
    var session:AVCaptureSession!
    var camera:AVCaptureDevice!
    var willSave = false
    
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
        view.backgroundColor = .red
        // カメラからの入力表示用にサイズ指定
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
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
        
        view.addSubview(cameraView)
        view.addSubview(headerView)
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
            make.height.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        })
        modeView.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalTo(footerView.snp.top)
            make.left.equalTo(0)
        })
        footerView.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
            make.height.equalTo(80)
            make.left.equalTo(0)
            make.bottom.equalToSuperview()
        })
        shutterLabel.snp.makeConstraints({ (make) in
            make.width.height.equalTo(60)
            make.centerX.centerY.equalToSuperview()
        })
        shutterButton.snp.makeConstraints({ (make) in
            make.width.height.equalTo(48)
            make.centerX.centerY.equalToSuperview()
        })
        
        // シャッターボタンの動作
        shutterButton.addTarget(self, action: #selector(CameraViewController.onDownShutterButton(sender:)), for: .touchDown)
        shutterButton.addTarget(self, action: #selector(CameraViewController.onUpShutterButton(sender:)), for: [.touchUpInside,.touchUpOutside])
        
        setupCamera()
    }

    override func viewWillAppear(_ animated: Bool) {
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
            self.willSave = true
            self.blackView.isHidden = true
        })
    }

    func setupCamera(){
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        device?.activeVideoMinFrameDuration = CMTimeMake(1, 30)
        
        do {
            input = try AVCaptureDeviceInput(device: device!)
            session = AVCaptureSession()
            
            if session.canSetSessionPreset(AVCaptureSession.Preset.high) {
                session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
            }
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            output = AVCaptureVideoDataOutput()
            output?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String : Int(kCVPixelFormatType_32BGRA)]
            output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
            output.alwaysDiscardsLateVideoFrames = true
            
            if session.canAddOutput(output){
                session.addOutput(output)
                session.startRunning()
                
                let previewLayer: AVCaptureVideoPreviewLayer = {
                    let layer = AVCaptureVideoPreviewLayer(session: session)
                    layer.videoGravity = AVLayerVideoGravity.resizeAspect
                    layer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    layer.bounds = self.cameraView.frame
                    let cameraView = self.cameraView
                    layer.position = CGPoint(x: cameraView.frame.width/2, y: cameraView.frame.height/2)
                    return layer
                }()
                self.cameraView.layer.addSublayer(previewLayer)
            }
        } catch {
            print(error)
        }
    }

    // 1/30秒ごとに呼ばれるデリゲート(キャプチャごと)
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if self.willSave {
            let image = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            self.willSave = false
        }
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
