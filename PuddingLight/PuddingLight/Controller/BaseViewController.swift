//
//  BaseViewController.swift
//  PuddingLight
//
//  Created by Ben on 2020/7/31.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit
import CoreBluetooth

class BaseViewController: UIViewController {
    var currentPage:Int = 1
    var centralManager:CBCentralManager!
    var bleTool:BlueToothTool!
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bleTool = BlueToothTool.instance
        centralManager = bleTool.centralManager
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //SN:0000000000000001;batteryValue:33,all:59000103000000000000000121
        //005a02000000000000000100040001010dac969151
    }
}


extension BaseViewController: CBCentralManagerDelegate , CBPeripheralDelegate{
    
    func startScanning() {
        centralManager.delegate = self
        //搜索服务id为1828的 设备
        centralManager.scanForPeripherals(withServices: [CBUUID(string: "1828")],  options: nil)
      //  centralManager.scanForPeripherals(withServices: nil,  options: nil)
        print("开始扫描")
        
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            startScanning()
        }
    }
    
    /** 连接成功 */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        bleTool.peripheral = peripheral
        self.centralManager?.stopScan()
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID.init(string: bleTool.Service_UUID)])
        self.alert?.message = "连接到设备"
        print("连接到设备")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.alert?.message = "连接失败"
        print("连接失败")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.alert?.message = "连接断开"
        print("断开连接")
        // 重新连接
        central.connect(peripheral, options: nil)
    }
    
    /** 发现服务 */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service: CBService in peripheral.services! {
            print("外设中的服务有：\(service)")
        }
        //本例的外设中只有一个服务
        let service = peripheral.services?.last
        // 根据UUID寻找服务中的特征
        peripheral.discoverCharacteristics([CBUUID.init(string: bleTool.Read_Characteristic_UUID)], for: service!)
        peripheral.discoverCharacteristics([CBUUID.init(string: bleTool.Write_Characteristic_UUID)], for: service!)
    }
    
    /** 发现特征 */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic: CBCharacteristic in service.characteristics! {
            print("外设中的特征有：\(characteristic)")
            if characteristic.uuid == CBUUID.init(string: bleTool.Read_Characteristic_UUID){
                bleTool.readCharacteristic = characteristic
            }else if characteristic.uuid == CBUUID.init(string: bleTool.Write_Characteristic_UUID){
                bleTool.writeCharacteristic = characteristic
            }
        }
        
        
        
        // 读取特征里的数据
        peripheral.readValue(for: bleTool.readCharacteristic!)
        // 订阅
        peripheral.setNotifyValue(true, for: bleTool.readCharacteristic!)
    }
    
    /** 订阅状态 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("订阅失败: \(error)")
            return
        }
        if characteristic.isNotifying {
            print("订阅成功")
            self.alert?.message = "连接成功"
        } else {
            print("取消订阅")
        }
    }
    
    /** 接收到数据 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let data = characteristic.value
        if data != nil {
            let string = DataTool.convertData(toHexStr: data!)
            print("接收数据:\(string)")
        }
    }
    
    /** 写入数据 */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("写入数据")
    }
}
