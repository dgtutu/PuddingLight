//
//  SeTableViewCell.swift
//  PuddingLight
//
//  Created by Ben on 2020/7/31.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class SeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var modeLabel: UILabel!
    
    @IBOutlet weak var styleLabel: UILabel!
    // let opts :KeyframeAnimationOptions = [.autoreverse,.repeat]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setUpCellWith(mode:String, style:String) {
        modeLabel.text = mode
        styleLabel.text = style
        switch mode {
        case "CCT特效":
            switch style {
                //            case "呼吸灯·白光":
            //                cctBreathWhiteAnimation()
            case "呼吸灯·暖光":
                cctBreathWramAnimation()
                
            case "闪电·快":
                cctThunderQuickAnimation()
            case "闪电·慢":
                cctThunderSlowAnimation()
            default:
                cctBreathWhiteAnimation()
            }
        case "RGB特效":
            switch style {
                //            case "渐变·慢":
            //                rgbSlowAnimation()
            case "渐变·快":
                rgbQuickAnimation()
            case "呼吸灯·红":
                rAnimation()
            case "呼吸灯·绿":
                gAnimation()
            case "呼吸灯·蓝":
                bAnimation()
            default:
                rgbSlowAnimation()
            }
            
        case "警灯特效":
            switch style {
                //            case "闪·红蓝":
            //                policeAnimation()
            case "闪·红":
                policeRedAnimation()
            case "闪·蓝":
                policeBlueAnimation()
            default:
                policeAnimation()
                
            }
        default:
            print("")
        }
        
    }
    
    func cctThunderQuickAnimation(){
        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {
            self.view.backgroundColor = .white
            self.view.alpha = 0.3
            
            self.view.backgroundColor = .black
            self.view.alpha = 0.8
        }) { (Bool) in
            
        }
    }
    
    func cctThunderSlowAnimation(){
        UIView.animate(withDuration: 2, delay: 0, options: .repeat, animations: {
            self.view.backgroundColor = .white
            self.view.alpha = 0.3
            
            self.view.backgroundColor = .black
            self.view.alpha = 0.8
        }) { (Bool) in
            
        }
    }
    
    func cctBreathWramAnimation(){
        UIView.animate(withDuration: 2, delay: 0, options: .repeat, animations: {
            self.view.backgroundColor = .orange
            self.view.alpha  = 0.3
            self.view.alpha  += 0.2
        }) { (Bool) in
            
        }
    }
    
    func cctBreathWhiteAnimation(){
        UIView.animate(withDuration: 2, delay: 0, options: .repeat, animations: {
            self.view.backgroundColor = .white
            self.view.alpha  = 0.2
            self.view.alpha  += 0.5
        }) { (Bool) in
            
        }
    }
    
    func rgbQuickAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            
            self.view.backgroundColor = .red
            self.view.backgroundColor = .blue
            
        }) { (Bool) in
            UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
                
                self.view.backgroundColor = .green
                
                
            }) { (Bool) in
                //
            }
        }
    }
    
    func rgbSlowAnimation(){
        
        
        UIView.animate(withDuration: 2, delay: 0, options: .allowUserInteraction, animations: {
            
            self.view.backgroundColor = .red
            self.view.backgroundColor = .blue
            
        }) { (Bool) in
            UIView.animate(withDuration: 2, delay: 0, options: .allowUserInteraction, animations: {
                
                self.view.backgroundColor = .green
                
                
            }) { (Bool) in
                //
            }
        }
        
    }
    
    func rAnimation(){
        UIView.animate(withDuration: 2, delay: 0, options: .repeat, animations: {
            
            self.view.backgroundColor = .red
            self.view.alpha  = 0.3
            self.view.alpha  += 0.9
        }) { (Bool) in
            
        }
    }
    
    func bAnimation(){
        UIView.animate(withDuration: 3, delay: 0, options: .repeat, animations: {
            
            self.view.backgroundColor = .blue
            self.view.alpha  = 0.3
            self.view.alpha  += 0.9
        }) { (Bool) in
            
        }
    }
    
    func gAnimation(){
        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {
            
            self.view.backgroundColor = .green
            self.view.alpha  = 0.3
            self.view.alpha  += 0.9
        }) { (Bool) in
            
        }
    }
    
    func policeAnimation(){
        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {
            
            self.view.backgroundColor = .red
            self.view.backgroundColor = .blue
        }) { (Bool) in
            
        }
    }
    
    func policeRedAnimation(){
        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {
            
            self.view.backgroundColor = .red
            self.view.backgroundColor = .black
        }) { (Bool) in
            
        }
    }
    
    func policeBlueAnimation(){
        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {
            
            self.view.backgroundColor = .blue
            self.view.backgroundColor = .black
        }) { (Bool) in
            
        }
    }
    
}
