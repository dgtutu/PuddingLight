//
//  HsiModel.swift
//  PuddingLight
//
//  Created by Ben on 2020/7/31.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit


class HsiDelegate: NSObject ,UITableViewDelegate ,UITableViewDataSource {
    var delegate:HsiTableViewCellDelegate?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.setSliderValue()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("once")
        
        return HsiPreset.customColorCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // print("index:\(indexPath.row)")
        
        let cell = Bundle.main.loadNibNamed("HsiTableViewCell", owner: self, options: nil)?.last as! HsiTableViewCell
        // let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HsiTableViewCell
        if indexPath.row == 0{
            cell.setUpWithImage(image: UIImage.init(named: "HSI")!)
        }else{
            switch indexPath.row {
            case 1:
                cell .setUpWithColor(0,100)
                
            case 2:
                cell.setUpWithColor(60,100)
                
            case 3:
                cell.setUpWithColor(120,100)
                
            case 4:
                cell.setUpWithColor(180,100)
                
            case 5:
                cell.setUpWithColor(240,100)
                
            case 6:
                cell.setUpWithColor(300,100)
                
            case 7:
                let array:[Int] = HsiPreset.getHsiParameterFromFile(WithFileName: "customColor1") as! [Int]
                cell.setUpWithColor(array[0], array[1])
                
            case 8:
                let array:[Int] = HsiPreset.getHsiParameterFromFile(WithFileName: "customColor2") as! [Int]
                cell.setUpWithColor(array[0], array[1])
                
            default:
               break
            }
        }
        
        return cell
        
        
    }
}

