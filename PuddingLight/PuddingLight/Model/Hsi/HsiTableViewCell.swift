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
    var hueValue: Int!
    var saturationValue: Int!
    var brightnessValue: Int!
    var delegate:HsiTableViewCellDelegate?
    
    @IBOutlet weak var hueValueLabel: UILabel!
    @IBOutlet weak var saturationValueLabel: UILabel!
    @IBOutlet weak var brightnessValueLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var drawView: DrawView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func setUpWithImage(image: UIImage, _ hue:Int = 180 ,_ saturation:Int = 50,_ brightness:Int = 100){
        
        myImageView.image = image
        drawView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        drawView.isHidden = false
        pointFlag = true
        hueValueLabel.text = "\(hue )"
        saturationValueLabel.text = "\(saturation )"
        brightnessValueLabel.text = "\(brightness )"
        let x:CGFloat = UIScreen.main.bounds.size.width * CGFloat(saturation) / 100.0
        let y:CGFloat = UIScreen.main.bounds.size.height * CGFloat(hue) / 360.0
        drawView.point = CGPoint.init(x:x, y:y)

        hueValue = hue
        saturationValue = saturation
        brightnessValue = brightness
    }
    
    func setUpPointWithColor(_ hue:Int ,_ saturation:Int ,_ brightness:Int ,_ alpha:Int )  {
        
        hueValueLabel.text = "\(hue)"
        saturationValueLabel.text = "\(saturation)"
        brightnessValueLabel.text = "\(brightness)"
        let x:CGFloat = UIScreen.main.bounds.size.width * CGFloat(saturation) / 100.0
               let y:CGFloat = UIScreen.main.bounds.size.height * CGFloat(hue) / 360.0
      //  print("x:\(x),y:\(y)")
        drawView.point = CGPoint.init(x:x, y:y)
       // print(self)
        hueValue = hue
        saturationValue = saturation
        brightnessValue = brightness
         
    }
    
    func setUpWithColor(_ hue:Int ,_ saturation:Int ,_ brightness:Int ,_ alpha:Int )  {
        
        let color = UIColor.init(hue: CGFloat(hue)/360.0, saturation: CGFloat(saturation)/100.0, brightness: CGFloat(brightness)/100.0, alpha: CGFloat(alpha))
        myImageView.backgroundColor = color
        pointFlag = false
        drawView.isHidden = true
        hueValueLabel.text = "\(hue)"
        saturationValueLabel.text = "\(saturation)"
        brightnessValueLabel.text = "\(brightness)"
        
        hueValue = hue
        saturationValue = saturation
        brightnessValue = brightness
         
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var cgPoint:CGPoint = CGPoint.init()
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            cgPoint = t.location(in: self.contentView)
        }
        if pointFlag == true{
            drawView.point = cgPoint
            hueValue = Int(drawView.point.y / self.bounds.size.height * 360)
            saturationValue = Int(drawView.point.x / self.bounds.size.width * 100)
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
            hueValue = Int(drawView.point.y / self.bounds.size.height * 360)
            saturationValue = Int(drawView.point.x / self.bounds.size.width * 100)
            hueValueLabel.text = String(format: "%.0f", arguments: [drawView.point.y / self.bounds.size.height * 360])
            saturationValueLabel.text = String(format: "%.0f", arguments: [drawView.point.x / self.bounds.size.width * 100])
        }
        delegate?.setSliderValue()
    }
    
}
