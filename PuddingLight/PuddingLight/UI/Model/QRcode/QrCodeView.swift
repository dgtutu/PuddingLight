//
//  QrCodeView.swift
//  PuddingLight
//
//  Created by Ben on 2020/8/8.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit

class QrCodeView: UIView {
    @IBOutlet weak var qrImageView: UIImageView!
    var content:String = "www.yconionca.com?data="
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func clickBackBtn(_ sender: Any) {
        self.removeFromSuperview()
        NotificationCenter.default.post(name: Notification.Name("QrcodeGoodBye"), object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        qrImageView.image = DataTool.qrImg(for: content, size: CGSize.init(width: 100, height: 100), waterImg: UIImage.init(named: "icon_qrlogo")!)
    }
    
}
