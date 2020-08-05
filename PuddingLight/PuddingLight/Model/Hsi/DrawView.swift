//
//  DrawView.swift
//  PuddingLight
//
//  Created by Ben on 2020/7/31.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var point:CGPoint = CGPoint.init() {
        willSet{
            setNeedsDisplay()
        }
        didSet{
            
        }
    }
    
    //    override func draw(_ layer: CALayer, in ctx: CGContext) {
    //        drawColor()
    //    }
    
    override func draw(_ rect: CGRect) {
        drawColor()
    }
    
    
    func drawColor(){
        var color = UIColor.init(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 0.4)
        let circle = UIBezierPath(arcCenter: point, radius: 8, startAngle: -CGFloat.pi, endAngle: CGFloat.pi, clockwise: true)
        
        color.set()
        circle.fill()
        circle.stroke()
        let path = UIBezierPath.init()
        //let path = UIBezierPath.init(rect: CGRect.init(x: point.x-8, y: point.y-8, width: 16, height: 16))
        color = .black
        path.move(to: CGPoint.init(x: point.x-4, y: point.y))
        path.addLine(to: CGPoint.init(x: point.x+4, y: point.y))
        
        path.move(to: CGPoint.init(x: point.x, y: point.y-4))
        path.addLine(to: CGPoint.init(x: point.x, y: point.y+4))
        color.set()
        path.stroke()
    }
    
}
