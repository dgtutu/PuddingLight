//
//  SeMenu.swift
//  PuddingLight
//
//  Created by Ben on 2020/8/7.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class SeMenu: UIView {
    
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var parameterBtn: UIButton!
    override func layoutSubviews() {
        superview?.layoutSubviews()
        brightnessSlider.value = Float(MainViewController.globalBrightnessValue) / 100.0
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
    
    @IBAction func changeBrightnessSlider(_ sender: Any) {
        MainViewController.globalBrightnessValue = Int(brightnessSlider.value * 100)
        BlueToothTool.instance.setBrightness(WithBrightness: MainViewController.globalBrightnessValue)
        
    }
    
    
    @IBAction func clickPatameterBtn(_ sender: Any) {
        parameterBtn.isHidden = true
        sliderView.isHidden = false
    }
    
    
    
    @IBAction func clickHideBtn(_ sender: Any) {
        
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.delegate?.showShowBtn()
        self.removeFromSuperview()
    }
    
}
