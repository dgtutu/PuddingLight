//
//  QrScanViewController.swift
//  PuddingLight
//
//  Created by Ben on 2020/8/8.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit
import swiftScan

class QrScanViewController: LBXScanViewController {
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        if let result = arrayResult.first {
            let msg = result.strScanned
            print("扫描结果:" + msg!)
            if msg?.hasPrefix("www.yconionca.com?data=") == true {
                let qrDataString = msg?.substring(from: 23)
                if qrDataString != "" || qrDataString != nil{
                    let index = DataTool.getSubStringNum(fromHexString: qrDataString!, fromLoc: 0, withLen: 2)
                    switch index {
                    case 2:
                        MainViewController.colorTemperatureValue = Int(DataTool.getSubStringNum(fromHexString: qrDataString!, fromLoc: 2, withLen: 2))
                        MainViewController.colorCompensationValue = Int(DataTool.getSubStringNum(fromHexString: qrDataString!, fromLoc: 4, withLen: 2))
                        MainViewController.globalBrightnessValue = Int(DataTool.getSubStringNum(fromHexString: qrDataString!, fromLoc:6, withLen: 2))
                        print("MainViewController.colorTemperatureValue:\(MainViewController.colorTemperatureValue),MainViewController.colorCompensationValue:\(MainViewController.colorCompensationValue),MainViewController.globalBrightnessValue:\(MainViewController.globalBrightnessValue)")
                        NotificationCenter.default.post(name: Notification.Name("Cct"), object: nil)
                        
                    case 3:
                        HsiTableViewCell.hueValue = Int(DataTool.getSubStringNum(fromHexString: qrDataString!, fromLoc: 2, withLen: 4))
                        HsiTableViewCell.saturationValue = Int(DataTool.getSubStringNum(fromHexString: qrDataString!, fromLoc: 6, withLen: 2))
                        MainViewController.globalBrightnessValue = Int(DataTool.getSubStringNum(fromHexString: qrDataString!, fromLoc: 8, withLen: 2))
                        NotificationCenter.default.post(name: Notification.Name("Hsi"), object: nil)
                    default:
                        print("")
                    }
                    
                    dismiss(animated: true) {
                       //self.removeFromParent()
                    }
                }
            }else{
                dismiss(animated: true) {
                   //self.removeFromParent()
                }
            }
            
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var style = LBXScanViewStyle()
        style.anmiationStyle = .NetGrid
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net")
        scanStyle = style
        
        
    }
}

