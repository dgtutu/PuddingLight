//
//  ColorimeterViewController.swift
//  PuddingLight
//
//  Created by Ben on 2020/8/7.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit
import AVFoundation

class ColorimeterViewController: UIViewController ,AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)!
        let image = UIImage.init(data: data)
        
        var h:CGFloat = 0
        var s:CGFloat = 0
        var l:CGFloat = 0
        for i in 0...9 {
            for j in 0...9 {
                let hvs_tmp:NSArray = DataTool.color(atPixel: CGPoint.init(x: Int(image!.size.width) / 2 - 5 + j, y: Int(image!.size.height) / 2 - 5 + i), andUIImage: image!) as NSArray
                
                h += hvs_tmp[0] as! CGFloat
                s += hvs_tmp[1] as! CGFloat
                l += hvs_tmp[2] as! CGFloat
                
            }
        }
        print(s)
        h = h/100
        s = s/100
        l = l/100
        s += 0.1
        if s >= 1 {
            s = 1
        }
        
        HsiTableViewCell.hueValue = Int(h)
        HsiTableViewCell.saturationValue = Int(s*100)
        MainViewController.globalBrightnessValue = Int(l*100)
        NotificationCenter.default.post(name: Notification.Name("Colorimeter"), object: nil)
        
        resultView.isHidden = false
        resultView.backgroundColor = UIColor.init(hue: h/360.0, saturation: s, brightness: l, alpha: 1.0)
        
        
    }
    
    var session:AVCaptureSession!
    var imageOutput: AVCapturePhotoOutput!
    var previewSubLayer: AVCaptureVideoPreviewLayer?
    var cameraMode :hcCameraMode!
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var preView: UIView!
    @IBOutlet weak var resultView: UIView!
    
    enum hcCameraMode:Int {
        case hcCameraMode9to16
        case hcCameraMode1to1
        case hcCameraMode3to4
        case bottom = 3
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectBtn.layer.cornerRadius = 5
        
        print("取色计启动")
        cameraMode = .hcCameraMode9to16
        session = AVCaptureSession.init()
        selectBtn.setTitle("选定", for: .normal)
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        if let device = captureDevice{
            let deviceInput = try! AVCaptureDeviceInput.init(device: device )
                   
                   if session.canAddInput(deviceInput){
                       session.addInput(deviceInput)
                   }
                   // 预览 session
                   loadPreviewLayer()
                   // output
                   imageOutput = AVCapturePhotoOutput.init()
                   session.addOutput(imageOutput)
                   session.startRunning()
        }
        
       
        
    }
    
    
    // 预览 session
    func loadPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer.init(session: session)
        let proportion = getPoportionByHcCameraMode(theCameraMode: cameraMode)
        previewLayer.frame = getFrameByProportion(proportion: proportion)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        preView.layer.masksToBounds = true
        preView.layer.insertSublayer(previewLayer, at: 0)
        
        
    }
    
    
    // 获取相机 input
    func getVideoInput() ->AVCaptureDeviceInput!{
        for input in session.inputs{
            let aVCaptureDeviceInput = input as! AVCaptureDeviceInput
            if aVCaptureDeviceInput.device.hasMediaType(AVMediaType.video) == true{
                return input as? AVCaptureDeviceInput
            }
        }
        return nil
    }
    
    // 根据 cameraMode 获取比例
    func getPoportionByHcCameraMode(theCameraMode: hcCameraMode) ->CGFloat  {
        
        if (theCameraMode == .hcCameraMode1to1) {
            return 1.0 / 1.0
        } else if (theCameraMode == .hcCameraMode3to4) {
            return 3.0 / 4.0
        } else {// hcCameraMode9to16
            return 9.0 / 16.0
        }
    }
    
    // 根据比例获取 frame
    func getFrameByProportion(proportion: CGFloat)   -> CGRect{
        
        let screenSize = CGSize.init(width: 90, height: 60)
        // let newSize = sizeWithSize(size: screenSize, proportion: proportion)
        return CGRect.init(x: 0, y: 0, width: 540, height: 960)
    }
    
    
    // 根据比例获得缩小后的 size
    func sizeWithSize(size: CGSize,proportion: CGFloat)  ->CGSize{
        let screenProportion:CGFloat = size.width / size.height
        var newSize:CGSize!
        if (proportion > screenProportion) {
            newSize.height  = size.height
            newSize.width = size.height * proportion
        } else {
            newSize.width = size.width
            newSize.height  = size.width / proportion
        }
        return newSize
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if resultView.isHidden {
            sender.setTitle("OK", for: .normal)
            
            var connection:AVCaptureConnection? = nil;
            for tempConnection in imageOutput.connections {
                for port in tempConnection.inputPorts {
                    if port.mediaType == AVMediaType.video {
                        connection = tempConnection
                        break
                    }
                }
                
                if connection != nil{
                    break
                }
            }
            let outputSetting = AVCapturePhotoSettings.init(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
                   imageOutput.capturePhoto(with: outputSetting, delegate: self)
        }else{
            resultView.isHidden = true
            sender.setTitle("选定", for: .normal)
        }
       
        
        
    }
    
    
    
}

