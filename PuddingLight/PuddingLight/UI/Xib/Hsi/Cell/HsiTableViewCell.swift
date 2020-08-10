//
//  HsiTableViewCell.swift
//  PuddingLight
//
//  Created by Ben on 2020/7/31.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit
protocol HsiTableViewCellDelegate {
    func setSliderValue()
}
class HsiTableViewCell: UITableViewCell {
    var pointFlag: Bool?
    static var hueValue: Int = 180{
        didSet{
            BlueToothTool.instance.setHsiMode(WithHue: hueValue, andSaturation: saturationValue)
        }
    }
    static var saturationValue: Int = 50{
        didSet{
            BlueToothTool.instance.setHsiMode(WithHue: hueValue, andSaturation: saturationValue)
        }
    }
    //static var brightnessValue: Int = 100
    var delegate:HsiTableViewCellDelegate?
    @IBOutlet weak var hueValueLabel: UILabel!
    @IBOutlet weak var saturationValueLabel: UILabel!
    @IBOutlet weak var brightnessValueLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var drawView: DrawView!
    
    //MARK: -加载通知
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifition), name: Notification.Name("Colorimeter"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifition), name: Notification.Name("Hsi"), object: nil)
    }
    
    @objc func onNotifition(notifi : Notification) {
        //        hueValueLabel.text = "\(HsiTableViewCell.hueValue)"
        //        saturationValueLabel.text = "\(HsiTableViewCell.saturationValue)"
        //        brightnessValueLabel.text = "\(MainViewController.globalBrightnessValue)"
        if pointFlag == true{
            setUpPointWithColor(HsiTableViewCell.hueValue, HsiTableViewCell.saturationValue)
        }else{
            setUpWithColor(HsiTableViewCell.hueValue, HsiTableViewCell.saturationValue)
        }
        
        delegate?.setSliderValue()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    func setBrightess(brightness:Int) {
        
        MainViewController.globalBrightnessValue = brightness
        BlueToothTool.instance.setBrightness(WithBrightness: brightness)
        brightnessValueLabel.text = "\(brightness )"
        if pointFlag == false{
            let color = UIColor.init(hue: CGFloat(HsiTableViewCell.hueValue)/360.0, saturation: CGFloat(HsiTableViewCell.saturationValue )/100.0, brightness:( CGFloat(MainViewController.globalBrightnessValue)  * 0.5 + 50 )/100.0, alpha:1.0)
            myImageView.backgroundColor = color
        }
    }
    
    func setUpWithImage(image: UIImage, _ hue:Int = 180 ,_ saturation:Int = 50){
        myImageView.image = image
        drawView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        drawView.isHidden = false
        pointFlag = true
        hueValueLabel.text = "\(hue )"
        saturationValueLabel.text = "\(saturation )"
        brightnessValueLabel.text = "\(MainViewController.globalBrightnessValue )"
        let x:CGFloat = UIScreen.main.bounds.size.width * CGFloat(saturation) / 100.0
        let y:CGFloat = UIScreen.main.bounds.size.height * CGFloat(hue) / 360.0
        drawView.point = CGPoint.init(x:x, y:y)
        HsiTableViewCell.hueValue = hue
        HsiTableViewCell.saturationValue = saturation
    }
    
    func setUpPointWithColor(_ hue:Int ,_ saturation:Int )  {
        hueValueLabel.text = "\(hue)"
        saturationValueLabel.text = "\(saturation)"
        brightnessValueLabel.text = "\(MainViewController.globalBrightnessValue)"
        let x:CGFloat = UIScreen.main.bounds.size.width * CGFloat(saturation) / 100.0
        let y:CGFloat = UIScreen.main.bounds.size.height * CGFloat(hue) / 360.0
        drawView.point = CGPoint.init(x:x, y:y)
        HsiTableViewCell.hueValue = hue
        HsiTableViewCell.saturationValue = saturation
    }
    
    func setUpWithColor(_ hue:Int ,_ saturation:Int)  {
        
        let color = UIColor.init(hue: CGFloat(hue)/360.0, saturation: CGFloat(saturation)/100.0, brightness:( CGFloat(MainViewController.globalBrightnessValue) * 0.5 + 50.0)/100.0, alpha:1.0)
        myImageView.backgroundColor = color
        pointFlag = false
        drawView.isHidden = true
        hueValueLabel.text = "\(hue)"
        saturationValueLabel.text = "\(saturation)"
        brightnessValueLabel.text = "\(MainViewController.globalBrightnessValue)"
        
        HsiTableViewCell.hueValue = hue
        HsiTableViewCell.saturationValue = saturation
    }
    
    //MARK: -触摸
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var cgPoint:CGPoint = CGPoint.init()
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            cgPoint = t.location(in: self.contentView)
        }
        if pointFlag == true{
            drawView.point = cgPoint
            HsiTableViewCell.hueValue = Int(drawView.point.y / self.bounds.size.height * 360)
            HsiTableViewCell.saturationValue = Int(drawView.point.x / self.bounds.size.width * 100)
            hueValueLabel.text = String(format: "%.0f", arguments: [drawView.point.y / self.bounds.size.height * 360])
            saturationValueLabel.text = String(format: "%.0f", arguments: [drawView.point.x / self.bounds.size.width * 100])
        }
        delegate?.setSliderValue()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var cgPoint:CGPoint = CGPoint.init()
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            cgPoint = t.location(in: self.contentView)
        }
        if pointFlag == true{
            drawView.point = cgPoint
            HsiTableViewCell.hueValue = Int(drawView.point.y / self.bounds.size.height * 360)
            HsiTableViewCell.saturationValue = Int(drawView.point.x / self.bounds.size.width * 100)
            hueValueLabel.text = String(format: "%.0f", arguments: [drawView.point.y / self.bounds.size.height * 360])
            saturationValueLabel.text = String(format: "%.0f", arguments: [drawView.point.x / self.bounds.size.width * 100])
        }
        delegate?.setSliderValue()
    }
    
}
