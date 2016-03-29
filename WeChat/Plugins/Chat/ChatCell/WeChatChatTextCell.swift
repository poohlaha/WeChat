//
//  WeChatChatTextCell.swift
//  WeChat
//
//  Created by Smile on 16/3/29.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//聊天文字cell
class WeChatChatTextCell:WeChatChatBaseCell {
    
    let messageLabel: UILabel//消息Label
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        messageLabel = UILabel(frame: CGRectZero)
        messageLabel.userInteractionEnabled = false
        messageLabel.numberOfLines = 0
        messageLabel.font = messageFont
        
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        backgroundImageView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //相对于messageLabel宽30,居中并偏上
        backgroundImageView.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Width, relatedBy: .Equal, toItem: messageLabel, attribute: .Width, multiplier: 1, constant: 30))
        backgroundImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterX, relatedBy: .Equal, toItem: backgroundImageView, attribute: .CenterX, multiplier: 1, constant: 0))
        backgroundImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterY, relatedBy: .Equal, toItem: backgroundImageView, attribute: .CenterY, multiplier: 1, constant: -5))
        
        //最大宽度
        messageLabel.preferredMaxLayoutWidth = 210
        
        backgroundImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .Height, relatedBy: .Equal, toItem: backgroundImageView, attribute: .Height, multiplier: 1, constant: -30))
        contentView.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -5))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setMessage(message: ChatMessage) {
        super.setMessage(message)
        let message = message as! TextMessage
        messageLabel.text = message.text
        
        //indicatorView.hidden = false
        if message.incoming != (tag == receiveTag) {
            
            if message.incoming {
                tag = receiveTag
                backgroundImageView.image = backgroundImage.incoming
                backgroundImageView.highlightedImage = backgroundImage.incomingHighlighed
                messageLabel.textColor = UIColor.blackColor()
            } else {
                tag = sendTag
                backgroundImageView.image = backgroundImage.outgoing
                backgroundImageView.highlightedImage = backgroundImage.outgoingHighlighed
                messageLabel.textColor = UIColor.whiteColor()
            }
            
            let messageConstraint : NSLayoutConstraint = backgroundImageView.constraints[1]
            messageConstraint.constant = -messageConstraint.constant
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundImageView.highlighted = selected
    }
}
