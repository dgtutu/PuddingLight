//
//  BaseViewController.swift
//  PuddingLight
//
//  Created by Ben on 2020/7/31.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var currentPage:Int = 1
    
    static let sharedManager = SingleManger() //单例
    let manager = BaseViewController.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
