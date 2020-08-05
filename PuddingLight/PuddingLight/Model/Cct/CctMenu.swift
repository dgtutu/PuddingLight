//
//  CctMenu.swift
//  PuddingLight
//
//  Created by Ben on 2020/8/3.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class CctMenu: UIView {
    
    
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var parameterBtn: UIButton!
    
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
