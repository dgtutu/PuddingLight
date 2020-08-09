//
//  BlueToothTool.swift
//  PuddingLight
//
//  Created by Ben on 2020/8/5.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit
import CoreBluetooth
import nRFMeshProvision


typealias DiscoveredPeripheral = (
    
    advData: String,
    
    peripheral: CBPeripheral,
    //外设
    rssi: Int
    //信号
)

class BlueToothTool: NSObject {
    
    static let instance: BlueToothTool = BlueToothTool()
    
    class func shareManager() -> BlueToothTool {
        return instance
    }
    var lastTime:Date?
    var SN:String = "0000000000000000"
    var centralManager: CBCentralManager! = CBCentralManager()
    var discoveredPeripherals: [DiscoveredPeripheral] = []
    var peripheral: CBPeripheral?
    var writeCharacteristic: CBCharacteristic?
    var readCharacteristic: CBCharacteristic?
    let Write_Characteristic_UUID: String = "2ADD"
    let Read_Characteristic_UUID: String = "2ADE"
    let Service_UUID: String = "1828"
    
    
    //MARK: -亮度设置
    func setBrightness(WithBrightness brightness:Int){
        print("设置的亮度:\(brightness)")
        let data = "5a02" + SN + "0002000105" + String(format: "%.2x", brightness)
        sendData(data)
    }
    
    
    //MARK: -HSI设置
    func setHsiMode(WithHue hue:Int, andSaturation saturation:Int)  {
        print("hue:\(hue),saturation:\(saturation)")
        let data = "5a02" + SN + "0004000100" + String(format: "%.4x%.2x", hue,saturation)
        sendData(data)
    }
    
    //MARK: -CCT设置
    func setCCTMode(WithColorTemperature colorTemperature:Int, AndCompensate compensate:Int){
        print("colorTemperature:\(colorTemperature),compensate:\(compensate)")
        let data = "5a02" + SN + "0004000101" + String(format: "%.4x%.2x", colorTemperature,compensate+10)
        sendData(data)
    }
    
    //MARK: -SE设置
    func setCCTMode(WithSpecialEffects specialEffects:Int){
        print("设置的SE:\(specialEffects)")
        let data = "5a02" + SN + "0002000102" + String(format: "%.2x", specialEffects)
        sendData(data)
    }
    
    func setRGBMode(WithSpecialEffects specialEffects:Int){
        print("设置的SE:\(specialEffects)")
        let data = "5a02" + SN + "0002000103" + String(format: "%.2x", specialEffects)
        sendData(data)
    }
    
    func setPoliceMode(WithSpecialEffects specialEffects:Int){
        print("设置的SE:\(specialEffects)")
        let data = "5a02" + SN + "0002000104" + String(format: "%.2x", specialEffects)
        sendData(data)
    }
    
    
    
    
    
    func sendData(_ stringData:String){
        if lastTime == nil  || lastTime!.timeIntervalSinceNow < -0.17{
            lastTime = Date.init()
            
            if stringData.count <= 34{
                sendShortData(stringData)
            }else{
                sendLongData(DataTool.getDivisionFromLongSendData(stringData) as NSArray)
            }
            
        }
        
    }
    
    private func sendShortData(_ data:String){
        print("------------------------------------------------")
        print("发送短数据:\(data)")
        let data = DataTool.convertHexStr(toData: "00" + data + DataTool.getCrcString(data))
        peripheral?.writeValue(data, for: writeCharacteristic!, type: .withoutResponse)
    }
    
    private func sendLongData(_ data:NSArray){
        print("------------------------------------------------")
        for division in data {
            print("发送长数据:\(division)")
            peripheral?.writeValue(DataTool.convertHexStr(toData: division as! String), for: writeCharacteristic!, type: .withoutResponse)
            
        }
    }
}
