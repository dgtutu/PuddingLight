//
//  RgbMenu.swift
//  PuddingLight
//
//  Created by Ben on 2020/8/4.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class RgbMenu: UIView {

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var whiteSlider: UISlider!
    @IBOutlet weak var wramWhiteSlider: UISlider!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var parameterBtn: UIButton!
    @IBOutlet weak var rgbSliderView: UIView!
    
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
    
    @IBAction func clickParameterBtn(_ sender: Any) {
        rgbSliderView.isHidden = false
        parameterBtn.isHidden = true
        shareBtn.isHidden = true
        scanBtn.isHidden = true
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.rgbLabelView.isHidden = true
    }
    
    @IBAction func clickHideBtn(_ sender: Any) {
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.delegate?.showShowBtn()
        vc.hsiDelegate.delegate = nil
        vc.rgbLabelView.isHidden = false
        self.removeFromSuperview()
    }
    
    @IBAction func changeRedSlider(_ sender: Any) {
        
        let value = redSlider.value * 100.0
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.redValue = value
        
    }
    
    @IBAction func changeGreenSlider(_ sender: Any) {
        let value = greenSlider.value * 100.0
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.greenValue = value
    }
    
    
    @IBAction func changeBlueSlider(_ sender: Any) {
        let value = blueSlider.value * 100.0
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.blueValue = value
    }
    
    
    @IBAction func changeWhiteSlider(_ sender: Any) {
        let value = whiteSlider.value * 100.0
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.whiteValue = value
    }
    
    @IBAction func changeWramWhiteSlider(_ sender: Any) {
        let value = wramWhiteSlider.value * 100.0
        let vc = getControllerfromview(view: self) as! MainViewController
        vc.wramWhiteValue = value
    }
 
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}
