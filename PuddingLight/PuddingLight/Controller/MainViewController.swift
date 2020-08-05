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
    @IBOutlet weak var colorTemperatureValueLabel: UILabel!
    @IBOutlet weak var cctBrightnessValueLabel: UILabel!
    @IBOutlet weak var colorTemperatureSlider: UISlider!
    @IBOutlet weak var cctBrightnessSlider: UISlider!
    @IBOutlet weak var cctSliderView: UIView!
    @IBOutlet weak var cctView: UIView!
    
    //MARK: -RGB
    @IBOutlet weak var rgbView: UIView!
    @IBOutlet weak var rgbLabelView: UIView!
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    @IBOutlet weak var whiteValueLabel: UILabel!
    @IBOutlet weak var wramWhiteValueLabel: UILabel!
    
    var redValue:Float!{
        willSet{
            redValueLabel.text = String(format: "%.0f", arguments: [newValue])
        }
        
    }
    var greenValue:Float!{
        willSet{
            greenValueLabel.text = String(format: "%.0f", arguments: [newValue])
        }
        
    }
    
    var blueValue:Float!{
        willSet{
            blueValueLabel.text = String(format: "%.0f", arguments: [newValue])
        }
        
    }
    
    var whiteValue:Float!{
        willSet{
            whiteValueLabel.text = String(format: "%.0f", arguments: [newValue])
        }
        
    }
    
    var wramWhiteValue:Float!{
        willSet{
            wramWhiteValueLabel.text = String(format: "%.0f", arguments: [newValue])
        }
        
    }
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var seTableView: UITableView!
    @IBOutlet weak var hsiTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAll()
        
    }
    
    @IBAction func changeColorTemperatureSlider(_ sender: Any) {
        let colorTemperatureValue = colorTemperatureSlider.value * 7200 + 2800
        self.colorTemperatureValueLabel.text = String(format: "%.0f", arguments: [colorTemperatureValue])
    }
    
    @IBAction func changeCctBrightnessSlider(_ sender: Any) {
        let cctBrightnessValue = cctBrightnessSlider.value * 100
        self.cctBrightnessValueLabel.text = String(format: "%.0f", arguments: [cctBrightnessValue])
    }
    
}


extension MainViewController :UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = myScrollView.frame.size.width
        currentPage = Int(floor((myScrollView.contentOffset.x - pageWidth / 2) / pageWidth ) + 1) + 1
        delegate?.sendCurrentPage(Page: currentPage)
        delegate?.changePage()
    }
    
}

extension MainViewController{
    func initAll()  {
        initCctView()
        initRgbView()
        initHsiTableView()
        initMyScorllView()
        initSeTableView()

    }
    
    func initCctView() {
        cctView.backgroundColor = .orange
        colorTemperatureValueLabel.text = "2800"
        cctBrightnessValueLabel.text = "100"
        cctSliderView.isHidden = true
        colorTemperatureValueLabel.text = "6500"
        cctBrightnessValueLabel.text = "50"
    }
    
    func initRgbView() {
        rgbView.backgroundColor = .gray
        redValue = 50.0
        greenValue = 50.0
        blueValue = 50.0
        whiteValue = 50.0
        wramWhiteValue = 50.0
    }
    
    func initHsiTableView() {
        //hsiTableView.register(UINib.init(nibName: "HsiTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        hsiTableView.delegate = hsiDelegate
        hsiTableView.dataSource = hsiDelegate
        hsiTableView.isPagingEnabled = true
        hsiTableView.rowHeight = UIScreen.main.bounds.height
        hsiTableView.contentInsetAdjustmentBehavior = .never
        hsiTableView.tableHeaderView = nil
        hsiTableView.tableFooterView = nil
    }
    
    func initSeTableView(){
      //  seTableView.register(UINib.init(nibName: "SeTableViewCell", bundle: nil), forCellReuseIdentifier: "SeCell")
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
