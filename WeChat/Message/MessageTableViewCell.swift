//
//  WeChatTableViewCell.swift
//  WeChat
//
//  Created by Smile on 16/1/5.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius:CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = (newValue > 0)
        }
    }
}

class MessageTableViewCell: WeChatTableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var time: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoView.tag = 1000
        title.tag = 1001
        content.tag = 1002
        time.tag = 1003
    }

}
