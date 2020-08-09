//
//  ViewController.swift
//  PuddingLight
//
//  Created by Ben on 2020/7/30.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate {
    func sendCurrentPage(Page: Int)
    func showShowBtn()
    func changePage()
    
    //  func hideSideView()
}


class MainViewController: BaseViewController {
    
    //
    //    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    //        print(touch)
    //        if (touch.view?.isKind(of: UISlider.self)) == true  {
    //            print("姬霓太美")
    //            return false
    //        }
    //        return true
    //    }
    
    //MARK: -代理
    var delegate:MainViewControllerDelegate?
    var floatVc:FloatViewController?
    var hsiDelegate: HsiDelegate = HsiDelegate()
    var seDelegate: SeDelegate = SeDelegate()
    
    //MARK: -CCT
    static var globalBrightnessValue:Int = 50
    static var colorTemperatureValue:Int = 4650
    static var colorCompensationValue:Int = 10
    @IBOutlet weak var colorCompensationSlider: UISlider!
    @IBOutlet weak var colorTemperatureValueLabel: UILabel!
    @IBOutlet weak var cctBrightnessValueLabel: UILabel!
    @IBOutlet weak var colorCompensationValueLabel: UILabel!
    @IBOutlet weak var colorTemperatureSlider: UISlider!
    @IBOutlet weak var cctBrightnessSlider: UISlider!
    @IBOutlet weak var cctSliderView: UIView!
    @IBOutlet weak var cctView: UIView!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var seTableView: UITableView!
    @IBOutlet weak var hsiTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAll()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifition), name: Notification.Name("Cct"), object: nil)
    }
    
    
     @objc func onNotifition(notifi : Notification) {
        colorTemperatureValueLabel.text = "\(MainViewController.colorTemperatureValue)"
        colorCompensationValueLabel.text = "\(MainViewController.colorCompensationValue)"
        cctBrightnessValueLabel.text = "\(MainViewController.globalBrightnessValue)"
        
        
        colorTemperatureSlider.value = Float(MainViewController.colorTemperatureValue - 2800 ) / 3700
        colorCompensationSlider.value = Float(MainViewController.colorCompensationValue)/100.0
        cctBrightnessSlider.value = Float(MainViewController.globalBrightnessValue)/100.0
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func changColorCompensationSlider(_ sender: Any) {
        
        MainViewController.colorCompensationValue = Int(colorCompensationSlider.value * 20)
        
        colorCompensationValueLabel.text = "\(MainViewController.colorCompensationValue - 10 )"
        
        bleTool.setCCTMode(WithColorTemperature: MainViewController.colorTemperatureValue, AndCompensate: MainViewController.colorCompensationValue)
        print("色调补偿值:\(MainViewController.colorCompensationValue)")
    }
    
    @IBAction func changeColorTemperatureSlider(_ sender: Any) {
        MainViewController.colorTemperatureValue = Int(colorTemperatureSlider.value * 3700 + 2800)
        print("色温值:\(MainViewController.colorTemperatureValue)")
        self.colorTemperatureValueLabel.text = "\(MainViewController.colorTemperatureValue)"
        bleTool.setCCTMode(WithColorTemperature: MainViewController.colorTemperatureValue, AndCompensate: MainViewController.colorCompensationValue)
    }
    
    @IBAction func changeCctBrightnessSlider(_ sender: Any) {
        
        MainViewController.globalBrightnessValue = Int(cctBrightnessSlider.value * 100)
        self.cctBrightnessValueLabel.text = "\(MainViewController.globalBrightnessValue)"
        bleTool.setBrightness(WithBrightness: MainViewController.globalBrightnessValue)
        
    }
    
}


extension MainViewController :UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = myScrollView.frame.size.width
        currentPage = Int(floor((myScrollView.contentOffset.x - pageWidth / 2) / pageWidth ) + 1) + 1
        delegate?.sendCurrentPage(Page: currentPage)
        delegate?.changePage()
        if currentPage == 1{
            let cell = hsiTableView.visibleCells.first as! HsiTableViewCell
            cell.brightnessValueLabel.text = "\(MainViewController.globalBrightnessValue)"
        }
    }
    
}

extension MainViewController{
    func initAll()  {
        initCctView()
        initHsiTableView()
        initMyScorllView()
        initSeTableView()
        
    }
    
    func initCctView() {
        cctView.backgroundColor = .orange
        cctSliderView.isHidden = true
        colorTemperatureValueLabel.text = "\(MainViewController.colorTemperatureValue)"
        cctBrightnessValueLabel.text = "\(MainViewController.globalBrightnessValue)"
        colorCompensationValueLabel.text = "\(MainViewController.colorCompensationValue - 10)"
    }
    
    func initHsiTableView() {
       
        hsiTableView.delegate = hsiDelegate
        hsiTableView.dataSource = hsiDelegate
        hsiTableView.isPagingEnabled = true
        hsiTableView.rowHeight = UIScreen.main.bounds.height
        hsiTableView.contentInsetAdjustmentBehavior = .never
        hsiTableView.tableHeaderView = nil
        hsiTableView.tableFooterView = nil
    }
    
    func initSeTableView(){
        seTableView.delegate = seDelegate
        seTableView.dataSource = seDelegate
        seTableView.isPagingEnabled = true
        seTableView.rowHeight = UIScreen.main.bounds.height
        seTableView.contentInsetAdjustmentBehavior = .never
        seTableView.tableHeaderView = nil
        seTableView.tableFooterView = nil
    }
    
    func initMyScorllView(){
        myScrollView.delegate = self
        myScrollView.isPagingEnabled = true
        myScrollView.showsHorizontalScrollIndicator = false
    }
    
}
