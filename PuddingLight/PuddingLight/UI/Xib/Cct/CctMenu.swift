//
//  CctMenu.swift
//  PuddingLight
//
//  Created by Ben on 2020/8/3.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class CctMenu: UIView {
    
    
    var qrCodeView:QrCodeView!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var parameterBtn: UIButton!
    var toolbar:UIToolbar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifition), name: Notification.Name("QrcodeGoodBye"), object: nil)
    }
    
    @objc func onNotifition(notifi : Notification) {
        if toolbar != nil{
        toolbar.removeFromSuperview()
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func clickScanBtn(_ sender: Any) {
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.performSegue(withIdentifier: "qrScan", sender: nil)
        
    }
    
    @IBAction func clickShareBtn(_ sender: Any) {
        let vc = getControllerfromview(view: self) as! MainViewController
        qrCodeView = vc.nibBundle?.loadNibNamed("QrCodeView", owner: vc, options: nil)?.first as? QrCodeView
        qrCodeView?.center = vc.view.center
        qrCodeView?.frame = vc.view.frame
        qrCodeView?.content += DataTool.getQRDataString(2, colorTemperature: Int32(MainViewController.colorTemperatureValue), colorCompensate: Int32(MainViewController.colorCompensationValue), brightness: Int32(MainViewController.globalBrightnessValue))
        
        toolbar = UIToolbar.init(frame: vc.view.frame)
        toolbar.barStyle = .black
        vc.view.addSubview(toolbar)
        vc.view.addSubview(qrCodeView!)
    }
    
    
    @IBAction func clickHideBtn(_ sender: Any) {
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.delegate?.showShowBtn()
        self.removeFromSuperview()
        vc.cctSliderView.isHidden = true
        
    }
    
    @IBAction func clickParameteBtn(_ sender: Any) {
        scanBtn.isHidden = true
        shareBtn.isHidden = true
        scanBtn.isHidden = true
        parameterBtn.isHidden = true
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.cctSliderView.isHidden = false
    }
    
    
    func getControllerfromview(view:UIView)->UIViewController?{
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
}
