//
//  ConnectingViewController.swift
//  PuddingLight
//
//  Created by Ben on 2020/8/5.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConnectingViewController: BaseViewController {
    @IBOutlet weak var barItem: UITabBarItem!
    @IBOutlet weak var peripheralTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralTableView.delegate = self
        peripheralTableView.dataSource = self
        peripheralTableView.separatorStyle = .none
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if centralManager.state == .poweredOn {
            //startScanning()
            
        }
    }
    
    @IBAction func clickScanBtn(_ sender: Any) {
//        stopScanning()
        if bleTool.discoveredPeripherals.count > 0{
            print("bleTool.discoveredPeripherals.count:\(bleTool.discoveredPeripherals.count)")
//            bleTool.discoveredPeripherals.removeAll()
            for i in 0..<(bleTool.discoveredPeripherals.count){
                bleTool.discoveredPeripherals.remove(at: 0)
                peripheralTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }
           
        }
        startScanning()
        
    }
    
    //实现代理
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let index = bleTool.discoveredPeripherals.firstIndex(where: { $0.peripheral == peripheral }) {
            if let cell = peripheralTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DeviceCell {
                let peripheral = bleTool.discoveredPeripherals[index].peripheral
                //                print(bleTool.discoveredPeripherals[index].advData)
                cell.deviceDidUpdate(peripheral.name,SerialNumber: bleTool.discoveredPeripherals[index].advData ,andRSSI: RSSI.intValue)
                
            }
        } else {
            let data = advertisementData["kCBAdvDataManufacturerData"] as? NSData
            var advData:String
            if data != nil {
                advData = DataTool.convertData(toHexStr: data! as Data)
            }else{
                advData = "Unkonwn SN"
            }
            print("advData:\(advData)\n")
            bleTool.discoveredPeripherals.append((advData , peripheral, RSSI.intValue))
            peripheralTableView.insertRows(at: [IndexPath(row: bleTool.discoveredPeripherals.count - 1, section: 0)], with: .fade)
        }
    }
}

extension ConnectingViewController: UITableViewDelegate ,UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bleTool.discoveredPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // print("index:\(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "peripheralCell", for: indexPath) as! DeviceCell
        
        let peripheral = bleTool.discoveredPeripherals[indexPath.row]
        //设置每个cell里的设备名称和信号
        
        cell.setupView(withPeripheralName:peripheral.peripheral.name,SerialNumber: peripheral.advData, andRSSI: peripheral.rssi)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        stopScanning()
//        print(bleTool.discoveredPeripherals[indexPath.row].peripheral.name!)
        bleTool.SN = bleTool.discoveredPeripherals[indexPath.row].advData.subString(rang: NSMakeRange(8, 16))
        alert = UIAlertController(title: "状态", message: "连接中...", preferredStyle: .alert)
        alert!.addAction(UIAlertAction(title: "关闭", style: .cancel) { action in
            action.isEnabled = false
            self.alert!.title   = "终止"
            self.alert!.message = "关闭连接 ..."
            
        })
        present(alert!, animated: true) {
            
            self.centralManager.connect(self.bleTool.discoveredPeripherals[indexPath.row].peripheral, options: nil)
            //连接蓝牙
        }
        
        
        
    }
    
}


