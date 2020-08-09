//
//  FloatViewController.swift
//  PuddingLight
//
//  Created by Ben on 2020/7/31.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit


class FloatViewController: BaseViewController,MainViewControllerDelegate {
    var hsiMenu:HsiMenu?
    var cctMenu:CctMenu?
    var seMenu:SeMenu?
    var mainVc:MainViewController?
    var colorimeterVC:ColorimeterViewController?
    
    @IBOutlet weak var colorimeterBtn: UIButton!
    @IBOutlet weak var closeSideViewBtn: UIButton!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var menuViewBtn: UIButton!
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet weak var mainController: UIView!
    @IBOutlet weak var lockBtn: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainVc" {
            mainVc = segue.destination as? MainViewController
            mainVc?.delegate = self
            //获得子控制器
        }
        
        //        if segue.identifier == "colorimeter" {
        //            colorimeterVC = segue.destination as? ColorimeterViewController
        //            colorimeterVC?.delegate = self
        //        }
    }
    @IBAction func clickMenuViewBtn(_ sender: Any) {
        sideView.isHidden = false
        closeSideViewBtn.isHidden = false
        
    }
    
    @IBAction func clickCloseSideViewBtn(_ sender: Any) {
        sideView.isHidden = true
        closeSideViewBtn.isHidden = true
    }
    
    func changePage() {
        //print(currentPage)
        pageController.currentPage = currentPage-1
        switch currentPage {
        case 1:
            colorimeterBtn.isHidden = false
            bleTool.setHsiMode(WithHue: HsiTableViewCell.hueValue, andSaturation: HsiTableViewCell.saturationValue)
            
            
            if hsiMenu?.isDescendant(of: (mainVc?.hsiTableView)!) == true {
                //hsiMenu?.removeFromSuperview()
                //                print("hsiyes")
                showBtn.isHidden = true
            }else if(hsiMenu == nil ||  hsiMenu?.isDescendant(of: (mainVc?.hsiTableView)!) == false){
                showShowBtn()
                //print("hsino")
            }
        case 2:
            colorimeterBtn.isHidden = true
            bleTool.setCCTMode(WithColorTemperature: MainViewController.colorTemperatureValue, AndCompensate: MainViewController.colorCompensationValue)
            mainVc?.cctBrightnessSlider.value = Float(MainViewController.globalBrightnessValue) / 100.0
            mainVc?.cctBrightnessValueLabel.text = "\(MainViewController.globalBrightnessValue)"
            
            
            if  cctMenu?.isDescendant(of: (mainVc?.cctView)!) == true{
                //            cctMenu?.removeFromSuperview()
                //            mainVc?.cctSliderView.isHidden = true
                // print("cctyes")
                showBtn.isHidden = true
            }else if (cctMenu == nil || cctMenu?.isDescendant(of: (mainVc?.cctView)!) == false){
                showShowBtn()
                //  print("cctno")
            }
            
        case 3:
            colorimeterBtn.isHidden = true
            bleTool.setCCTMode(WithSpecialEffects: 1)
            if  seMenu?.isDescendant(of: (mainVc?.seTableView)!) == true{
                //            cctMenu?.removeFromSuperview()
                //            mainVc?.cctSliderView.isHidden = true
                // print("cctyes")
                showBtn.isHidden = true
            }else if (seMenu == nil || seMenu?.isDescendant(of: (mainVc?.seTableView)!) == false){
                showShowBtn()
                //  print("cctno")
            }
            
        default:
            showBtn.isHidden = true
        }
    }
    
    func sendCurrentPage(Page: Int) {
        currentPage = Page
        // removeMenuView()
    }
    
    func showShowBtn() {
        showBtn.isHidden = false
    }
    
    @IBAction func clickShowBtn(_ sender: Any) {
        
        showBtn.isHidden = true
        print(bleTool.discoveredPeripherals)
        switch currentPage {
        case 1:
            
            hsiMenu = nibBundle?.loadNibNamed("HsiMenu", owner: self, options: nil)?.first as? HsiMenu
            hsiMenu?.translatesAutoresizingMaskIntoConstraints = false
            hsiMenu?.sliderView.isHidden = true
            mainVc?.hsiTableView .addSubview(hsiMenu!)
            
            //            let topConstraint = NSLayoutConstraint.init(item: hsiMenu, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: UIScreen.main.bounds.height * 8/9)
            //            topConstraint.isActive = true
            //
            let leftConstraint = NSLayoutConstraint.init(item: hsiMenu!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 10)
            leftConstraint.isActive = true
            
            let bottomConstraint = NSLayoutConstraint.init(item: hsiMenu!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: UIScreen.main.bounds.height * -1/10)
            bottomConstraint.isActive = true
            
            //添加距离左边20
            let rightConstraint = NSLayoutConstraint.init(item: hsiMenu!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -20)
            rightConstraint.isActive = true
            
            //添加高为100
            let heightConstraint = NSLayoutConstraint.init(item: hsiMenu!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.height * 3/10)
            heightConstraint.isActive = true
        case 2:
            
            cctMenu = nibBundle?.loadNibNamed("CctMenu", owner: self, options: nil)?.first as? CctMenu
            cctMenu?.translatesAutoresizingMaskIntoConstraints = false
            mainVc?.cctView .addSubview(cctMenu!)
            // cctMenu?.frame = CGRect.init(x: 40, y: 40, width: 30, height: 40)
            let leftConstraint = NSLayoutConstraint.init(item: cctMenu!, attribute: .left, relatedBy: .equal, toItem: mainVc?.cctSliderView, attribute: .right, multiplier: 1.0, constant: 0)
            leftConstraint.isActive = true
            
            let bottomConstraint = NSLayoutConstraint.init(item: cctMenu!, attribute: .bottom, relatedBy: .equal, toItem: mainVc?.cctView, attribute: .bottom, multiplier: 1.0, constant: UIScreen.main.bounds.height * -1/10)
            bottomConstraint.isActive = true
            
            //添加距离左边20
            let rightConstraint = NSLayoutConstraint.init(item: cctMenu!, attribute: .right, relatedBy: .equal, toItem: mainVc?.cctView, attribute: .right, multiplier: 1.0, constant: -10)
            rightConstraint.isActive = true
            
            //添加高为100
            let heightConstraint = NSLayoutConstraint.init(item: cctMenu!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.height * 4/10)
            heightConstraint.isActive = true
            
            
        default:
            
            seMenu = nibBundle?.loadNibNamed("SeMenu", owner: self, options: nil)?.first as? SeMenu
            seMenu?.translatesAutoresizingMaskIntoConstraints = false
            seMenu?.sliderView.isHidden = true
            mainVc?.seTableView .addSubview(seMenu!)
            
            //            let topConstraint = NSLayoutConstraint.init(item: hsiMenu, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: UIScreen.main.bounds.height * 8/9)
            //            topConstraint.isActive = true
            //
            let leftConstraint = NSLayoutConstraint.init(item: seMenu!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 10)
            leftConstraint.isActive = true
            
            let bottomConstraint = NSLayoutConstraint.init(item: seMenu!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: UIScreen.main.bounds.height * -1/10)
            bottomConstraint.isActive = true
            
            //添加距离左边20
            let rightConstraint = NSLayoutConstraint.init(item: seMenu!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -20)
            rightConstraint.isActive = true
            
            
            //            //添加宽为200
            //            let widthConstraint = NSLayoutConstraint.init(item: hsiMenu, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 400)
            //            widthConstraint.isActive = true
            //
            //添加高为100
            let heightConstraint = NSLayoutConstraint.init(item: seMenu!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.height * 3/10)
            heightConstraint.isActive = true
        }
    }
    
    @IBAction func clickLockBtn(_ sender: Any) {
        
        switch lockBtn.isSelected {
        case false:
            
            mainVc?.hsiTableView.isScrollEnabled = false
            mainVc?.myScrollView.isScrollEnabled = false
            
            lockBtn.isSelected = true
            
            
        default:
            
            mainVc?.hsiTableView.isScrollEnabled = true
            mainVc?.myScrollView.isScrollEnabled = true
            
            lockBtn.isSelected = false
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        pageController.numberOfPages = 3
        pageController.currentPage = 0
        sideView.isHidden = true
        closeSideViewBtn.isHidden = true
        
    }
    
    
}
