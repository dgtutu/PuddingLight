//
//  HsiMenu.swift
//  PuddingLight
//
//  Created by Ben on 2020/8/1.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class HsiMenu: UIView ,HsiTableViewCellDelegate {
    var qrCodeView:QrCodeView?
    @IBOutlet weak var preSetBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var parameterBtn: UIButton!
    @IBOutlet weak var hueSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var sliderView: UIView!
    var toolbar:UIToolbar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifition), name: Notification.Name("QrcodeGoodBye"), object: nil)
    }
    
    @objc func onNotifition(notifi : Notification) {
        if toolbar != nil {
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
        qrCodeView?.content += DataTool.getQRDataString(3, colorHue: Int32(HsiTableViewCell.hueValue), colorSaturation: Int32(HsiTableViewCell.saturationValue), brightness: Int32(MainViewController.globalBrightnessValue))
        toolbar = UIToolbar.init(frame: vc.view.frame)
        toolbar.barStyle = .black
        vc.view.addSubview(toolbar)
        vc.view.addSubview(qrCodeView!)
        
    }
    
    func setSliderValue() {
        hueSlider.value = Float(HsiTableViewCell.hueValue)/360.0
        saturationSlider.value = Float(HsiTableViewCell.saturationValue)/100.0
        brightnessSlider.value = Float(MainViewController.globalBrightnessValue)/100.0
    }
    
    func setUpCellHueAndSaturation() {
        let vc = getControllerfromview(view: self) as! MainViewController
        let cell = vc.hsiTableView.visibleCells.first as! HsiTableViewCell
        
        if cell.pointFlag == true{
            cell.setUpPointWithColor(Int(hueSlider.value * 360), Int(saturationSlider.value * 100))
        }
        if cell.pointFlag == false{
            cell.setUpWithColor(Int(hueSlider.value * 360), Int(saturationSlider.value * 100))
        }
    }
    
    func setUpCellBrightness() {
        let vc = getControllerfromview(view: self) as! MainViewController
        let cell = vc.hsiTableView.visibleCells.first as! HsiTableViewCell
        cell.setBrightess(brightness: Int(brightnessSlider.value * 100))
    }
    
    @IBAction func changeHueSlider(_ sender: Any) {
        setUpCellHueAndSaturation()
    }
    
    @IBAction func changeSaturationSlider(_ sender: Any) {
        setUpCellHueAndSaturation()
    }
    
    @IBAction func changeBrightnessSlider(_ sender: Any) {
        setUpCellBrightness()
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
    
    
    @IBAction func clickHideBtn(_ sender: Any) {
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.delegate?.showShowBtn()
        let cell = vc.hsiTableView.visibleCells.first as! HsiTableViewCell
        cell.delegate = nil
        vc.hsiDelegate.delegate = nil
        self.removeFromSuperview()
        
    }
    
    @IBAction func clickParameterBtn(_ sender: Any) {
        sliderView.isHidden = false
        let vc = getControllerfromview(view: self) as! MainViewController
        let cell = vc.hsiTableView.visibleCells.first as! HsiTableViewCell
        cell.delegate = self
        vc.hsiDelegate.delegate = self
        
        parameterBtn.isHidden = true
        scanBtn.isHidden = true
        shareBtn.isHidden = true
        preSetBtn.isHidden = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let vc = getControllerfromview(view: self) as! MainViewController
        let cell = vc.hsiTableView.visibleCells.first as! HsiTableViewCell
        cell.delegate = self
        hueSlider.value = Float(HsiTableViewCell.hueValue)/360.0
        saturationSlider.value = Float(HsiTableViewCell.saturationValue)/100.0
        brightnessSlider.value = Float(MainViewController.globalBrightnessValue)/100.0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    
    
}
