//
//  HSITableViewModel.swift
//  PuddingLight
//
//  Created by Ben on 2020/7/30.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class HSITableViewModel: NSObject ,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("hhhh")
        let cell = tableView.dequeueReusableCell(withIdentifier: "hh")!
        return cell
    }
    
    

}
