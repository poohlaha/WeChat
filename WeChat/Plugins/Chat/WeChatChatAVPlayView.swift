//
//  WeChatChatAVPlayView.swift
//  WeChat
//
//  Created by Smile on 16/3/29.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
class WeChatChatAVPlayView: UIView {

    
    var playView: UIView!
    var slider: UISlider!
    var timerIndicator: UILabel!
    
    // MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        NSLog("deinit")
    }
    
    func setup() {
        backgroundColor = UIColor.blackColor()
        playView = UIView()
        
        slider = UISlider()
        slider.setThumbImage(UIImage.imageWithColor(UIColor.redColor()), forState: .Normal)
        
        timerIndicator = UILabel()
        timerIndicator.font = UIFont.systemFontOfSize(12.0)
        timerIndicator.textColor = UIColor.whiteColor()
        
        addSubview(playView)
        addSubview(slider)
        addSubview(timerIndicator)
        
        playView.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        timerIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: playView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playView, attribute: .Bottom, relatedBy: .Equal, toItem: slider, attribute: .Top, multiplier: 1, constant: -5))
        
        addConstraint(NSLayoutConstraint(item: slider, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: slider, attribute: .Right, relatedBy: .Equal, toItem: timerIndicator, attribute: .Left, multiplier: 1, constant: -5))
        addConstraint(NSLayoutConstraint(item: slider, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -5))
        
        addConstraint(NSLayoutConstraint(item: timerIndicator, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -5))
        addConstraint(NSLayoutConstraint(item: timerIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: slider, attribute: .CenterY, multiplier: 1, constant: 0))
    }
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
}
