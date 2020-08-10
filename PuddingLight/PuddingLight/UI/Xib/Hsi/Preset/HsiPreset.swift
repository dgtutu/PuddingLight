//
//  HsiPreset.swift
//  PuddingLight
//
//  Created by Ben on 2020/8/9.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class HsiPreset: UIView {
    static var customColorCount: Int {
        get{
            let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
            let fp1 = filePath[0] + "/" + "customColor1"
            let fp2 = filePath[0] + "/" + "customColor2"
            let fm = FileManager.default
            let exist1 = fm.fileExists(atPath: fp1)
            let exist2 = fm.fileExists(atPath: fp2)
            if exist1 == true && exist2 == true{
                return 9
            }else if exist1 == true || exist2 == true{
                return 8
            }else {
                return 7
            }
        }
        
        
    }
    
    var initFlag = false
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var preset1Btn: UIButton!
    @IBOutlet weak var preset2Btn: UIButton!
    @IBOutlet weak var preset3Btn: UIButton!
    @IBOutlet weak var preset4Btn: UIButton!
    @IBOutlet weak var preset5Btn: UIButton!
    @IBOutlet weak var preset6Btn: UIButton!
    @IBOutlet weak var preset7Btn: UIButton!
    @IBOutlet weak var preset8Btn: UIButton!
    @IBOutlet weak var preset9Btn: UIButton!
    var vc:MainViewController!
    
    func jump2Index(AtIndex index:Int){
        vc.hsiTableView.selectRow(at: IndexPath.init(item: index, section: 0), animated: true, scrollPosition: .middle )
    }
    
    @IBAction func clickPreset1Btn(_ sender: Any) {
        jump2Index(AtIndex: 0)
    }
    
    @IBAction func clickPreset2Btn(_ sender: Any) {
        jump2Index(AtIndex: 1)
    }
    
    @IBAction func clickPreset3Btn(_ sender: Any) {
        jump2Index(AtIndex: 2)
    }
    
    @IBAction func clickPreset4Btn(_ sender: Any) {
        jump2Index(AtIndex: 3)
    }
    @IBAction func clickPreset5Btn(_ sender: Any) {
        jump2Index(AtIndex: 4)
    }
    
    @IBAction func clickPreset6Btn(_ sender: Any) {
        jump2Index(AtIndex: 5)
    }
    
    @IBAction func clickPreset7Btn(_ sender: Any) {
        jump2Index(AtIndex: 6)
    }
    
    class func removeParameterFile(WithFileName name:String){
        do{
            let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
            let fp = filePath[0] + "/" + name
            let url = NSURL(fileURLWithPath: fp)
            let fileManger = FileManager.default
            try fileManger.removeItem(at: url as URL)
            print("Success to remove file.")
        }catch{
            print("Failed to remove file.")
        }
    }
    
    class func writeHsiParameterToFile(WithFileName name:String){
        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let fp = filePath[0] + "/" + name
        //let url = NSURL(fileURLWithPath: fp)
        do{
            NSArray(array: [HsiTableViewCell.hueValue,HsiTableViewCell.saturationValue, MainViewController.globalBrightnessValue]).write(toFile: fp, atomically: true)
        }catch{
            
        }
    }
    
    class func getHsiParameterFromFile(WithFileName name:String) -> NSArray?{
        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let fp = filePath[0] + "/" + name
        let fm = FileManager.default
        let exist = fm.fileExists(atPath: fp)
        if exist{
            
            return NSArray(contentsOfFile: fp)
        }
        return nil
        
    }
    
    @IBAction func clickPreset8Btn(_ sender: Any) {
        switch HsiPreset.customColorCount {
        case 7:
            HsiPreset.writeHsiParameterToFile(WithFileName: "customColor1")
            vc.hsiTableView.insertRows(at: [IndexPath(row: HsiPreset.customColorCount - 1, section: 0)], with: .fade)
            jump2Index(AtIndex: 7)
            preset8Btn.setImage(nil, for: .normal)
            preset8Btn.backgroundColor = UIColor.init(hue: CGFloat(HsiTableViewCell.hueValue) / 360.0, saturation: CGFloat(HsiTableViewCell.saturationValue) / 100.0, brightness: CGFloat(MainViewController.globalBrightnessValue) / 100.0, alpha: 1.0)
            preset9Btn.isHidden = false
        case 8,9:
            jump2Index(AtIndex: 7)
        default:
            break
        }
    }
    
    @objc func press8Btn(longPress:UILongPressGestureRecognizer){
        if longPress.state == .began{
            switch HsiPreset.customColorCount {
            case 7:
                break
                
            case 8:
                preset9Btn.isHidden = true
                preset9Btn.setImage(UIImage.init(named: "add2"), for: .normal)
                preset8Btn.setImage(UIImage.init(named: "add2"), for: .normal)
                preset8Btn.backgroundColor = UIColor.init(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 0.0)
                jump2Index(AtIndex: 6)
                let cell = vc.hsiTableView.visibleCells.first as! HsiTableViewCell
                cell.setUpWithColor(300, 100)
               // cell.setBrightess(brightness: 50)
                HsiPreset.removeParameterFile(WithFileName: "customColor1")
                vc.hsiTableView.deleteRows(at: [IndexPath(row: HsiPreset.customColorCount - 1, section: 0)], with: .fade)
                
            case 9:
                preset9Btn.isHidden = false
                preset9Btn.setImage(UIImage.init(named: "add2"), for: .normal)
                preset9Btn.backgroundColor = UIColor.init(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 0.0)
                let array:[Int] = HsiPreset.getHsiParameterFromFile(WithFileName: "customColor2") as! [Int]
                preset8Btn.backgroundColor = UIColor.init(hue: CGFloat(array[0]) / 360.0 , saturation: CGFloat(array[1]) / 100.0, brightness: CGFloat(array[2]) / 100.0, alpha: 1.0)
                preset8Btn.setImage(nil, for: .normal)
                HsiPreset.removeParameterFile(WithFileName: "customColor1")
                HsiPreset.removeParameterFile(WithFileName: "customColor2")
                jump2Index(AtIndex: 7)
                let cell = vc.hsiTableView.visibleCells.first as! HsiTableViewCell
                cell.setUpWithColor(array[0], array[1])
                //cell.setBrightess(brightness: array[2])
                HsiPreset.writeHsiParameterToFile(WithFileName: "customColor1")
                vc.hsiTableView.deleteRows(at: [IndexPath(row: HsiPreset.customColorCount - 1, section: 0)], with: .fade)
                
                break
            default:
                break
            }
        }
    }
    
    @IBAction func clickPreset9Btn(_ sender: Any) {
        switch HsiPreset.customColorCount {
        case 8:
            HsiPreset.writeHsiParameterToFile(WithFileName: "customColor2")
            vc.hsiTableView.insertRows(at: [IndexPath(row: HsiPreset.customColorCount - 1, section: 0)], with: .fade)
            jump2Index(AtIndex: 8)
            preset9Btn.setImage(nil, for: .normal)
            preset9Btn.backgroundColor = UIColor.init(hue: CGFloat(HsiTableViewCell.hueValue) / 360.0, saturation: CGFloat(HsiTableViewCell.saturationValue) / 100.0, brightness: CGFloat(MainViewController.globalBrightnessValue) / 100.0, alpha: 1.0)
        case 9:
            jump2Index(AtIndex: 8)
        default:
            break
        }
        
    }
    
    @objc func press9Btn(longPress:UILongPressGestureRecognizer){
        if longPress.state == .began{
            switch HsiPreset.customColorCount {
                
            case 8:
                break
                
            case 9:
                preset9Btn.setImage(UIImage.init(named: "add2"), for: .normal)
                preset9Btn.backgroundColor = UIColor.init(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 0.0)
                 let array:[Int] = HsiPreset.getHsiParameterFromFile(WithFileName: "customColor1") as! [Int]
                jump2Index(AtIndex: 7)
                let cell = vc.hsiTableView.visibleCells.first as! HsiTableViewCell
                cell.setUpWithColor(array[0], array[1])
               // cell.setBrightess(brightness: array[2])
                HsiPreset.removeParameterFile(WithFileName: "customColor2")
                vc.hsiTableView.deleteRows(at: [IndexPath(row: HsiPreset.customColorCount - 1, section: 0)], with: .fade)
                
                break
            default:
                break
            }
        }
    }
    
    
    @IBAction func clickBackBtn(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("HSiPresetGoodBye"), object: nil)
        removeFromSuperview()
    }
    
    
    //MARK: -从view获得控制器
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
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if initFlag == false{
            let longPress8 = UILongPressGestureRecognizer.init(target: self, action: #selector(press8Btn))
            longPress8.minimumPressDuration=0.5;
            //            longPress8.numberOfTouchesRequired=1
            
            let longPress9 = UILongPressGestureRecognizer.init(target: self, action: #selector(press9Btn))
            longPress9.minimumPressDuration=0.5;
            //            longPress9.numberOfTouchesRequired=1
            
            self.preset8Btn.addGestureRecognizer(longPress8)
            self.preset9Btn.addGestureRecognizer(longPress9)
            initFlag = true
        }
        
        vc = getControllerfromview(view: self) as? MainViewController
        bottomView.layer.cornerRadius = 10
        preset1Btn.layer.cornerRadius = 10
        preset1Btn.layer.masksToBounds = true
        preset2Btn.layer.cornerRadius = 10
        preset3Btn.layer.cornerRadius = 10
        preset4Btn.layer.cornerRadius = 10
        preset5Btn.layer.cornerRadius = 10
        preset6Btn.layer.cornerRadius = 10
        preset7Btn.layer.cornerRadius = 10
        preset8Btn.layer.cornerRadius = 10
        preset8Btn.layer.masksToBounds = true
        preset9Btn.layer.cornerRadius = 10
        preset9Btn.layer.masksToBounds = true
        
        if HsiPreset.customColorCount == 7{
            preset8Btn.setImage(UIImage.init(named: "add2"), for: .normal)
            preset9Btn.isHidden = true
        }
        
        if HsiPreset.customColorCount == 8{
            let array:[Int] = HsiPreset.getHsiParameterFromFile(WithFileName: "customColor1") as! [Int]
            preset8Btn.backgroundColor = UIColor.init(hue: CGFloat(array[0]) / 360.0, saturation: CGFloat(array[1]) / 100.0, brightness: CGFloat(array[2]) / 100.0, alpha: 1.0)
            preset8Btn.setImage(nil, for: .normal)
            preset9Btn.isHidden = false
        }
        
        if HsiPreset.customColorCount == 9{
            let array:[Int] = HsiPreset.getHsiParameterFromFile(WithFileName: "customColor1") as! [Int]
            preset8Btn.backgroundColor = UIColor.init(hue: CGFloat(array[0]) / 360.0, saturation: CGFloat(array[1]) / 100.0, brightness: CGFloat(array[2]) / 100.0, alpha: 1.0)
            preset8Btn.setImage(nil, for: .normal)
            
            preset9Btn.isHidden = false
            let array2:[Int] = HsiPreset.getHsiParameterFromFile(WithFileName: "customColor2") as! [Int]
            preset9Btn.backgroundColor = UIColor.init(hue: CGFloat(array2[0]) / 360.0, saturation: CGFloat(array2[1]) / 100.0, brightness: CGFloat(array2[2]) / 100.0, alpha: 1.0)
            preset9Btn.setImage(nil, for: .normal)
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
