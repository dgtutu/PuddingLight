//
//  SeDelegate.swift
//  PuddingLight
//
//  Created by Ben on 2020/7/31.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class SeDelegate: NSObject ,UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SeTableViewCell", owner: self, options: nil)?.last as! SeTableViewCell
     //   let cell = tableView.dequeueReusableCell(withIdentifier: "SeCell", for: indexPath) as! SeTableViewCell
        switch indexPath.row {
        case 0:
            cell.setUpCellWith(mode: "CCT特效", style: "闪电·快")
        case 1:
            cell.setUpCellWith(mode: "CCT特效", style: "闪电·慢")
            
        case 2:
            cell.setUpCellWith(mode: "CCT特效", style: "呼吸灯·白光")
            
        case 3:
            cell.setUpCellWith(mode: "CCT特效", style: "呼吸灯·暖光")
            
        case 4:
            cell.setUpCellWith(mode: "RGB特效", style: "渐变·快")
            
        case 5:
            cell.setUpCellWith(mode: "RGB特效", style: "渐变·慢")
        case 6:
            cell.setUpCellWith(mode: "RGB特效", style: "呼吸灯·红")
            
        case 7:
            cell.setUpCellWith(mode: "RGB特效", style: "呼吸灯·绿")
            
        case 8:
            cell.setUpCellWith(mode: "RGB特效", style: "呼吸灯·蓝")
            
        case 9:
            cell.setUpCellWith(mode: "警灯特效", style: "闪·红蓝")
            
        case 10:
            cell.setUpCellWith(mode: "警灯特效", style: "闪·红")
        case 11:
            cell.setUpCellWith(mode: "警灯特效", style: "闪·蓝")
      
            
        default:
            print("")
        }
        return cell
    }
    
    
}
