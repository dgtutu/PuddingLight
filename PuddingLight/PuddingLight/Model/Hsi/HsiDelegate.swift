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
        return 9
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
                    cell .setUpWithColor(0,100,100, 1)
                    
                case 2:
                    cell.setUpWithColor(60,100,100,1)
                   
                case 3:
                    cell.setUpWithColor(120,100,100,1)
                   
                case 4:
                    cell.setUpWithColor(180,100,100,1)
                    
                case 5:
                    cell.setUpWithColor(240,100,100,1)
                    
                case 6:
                   cell.setUpWithColor(300,100,100,1)
                    
                    
                default:
                    cell.setUpWithImage(image: UIImage.init(named: "HSI")!)
                }
            }
            
            return cell
        
        
    }
}

