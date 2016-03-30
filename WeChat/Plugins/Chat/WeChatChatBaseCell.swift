//
//  WeChatChatBaseCell.swift
//  WeChat
//
//  Created by Smile on 16/3/29.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

let receiveTag = 0//接收标识
let sendTag = 1//发送标识
let iconImageTag = 10010
let backgroundImageTag = 10020
let indicatorTag = 10030//消失状态标识

let timeFont = UIFont.systemFontOfSize(12.0)
let messageFont = UIFont.systemFontOfSize(16.0)
let indicatorFont = UIFont.systemFontOfSize(10.0)

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        
        let rect = CGRectMake(0, 0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //创建并返回一个具有指定的值上限的新形象的对象
    func resizeImage() -> UIImage {
        return self.stretchableImageWithLeftCapWidth(Int(self.size.width / CGFloat(2)), topCapHeight: Int(self.size.height / CGFloat(2)))
    }
}

//隐天tableview base cell
class WeChatChatBaseCell: UITableViewCell {

    let iconImageView: UIImageView          //用户头像
    let backgroundImageView: UIImageView    //cell背景色
    let timeLabel: UILabel                  //时间Label
    let indicatorView: UIButton             //消息状态按钮
    
    let iconImageViewWidth:CGFloat = 45     //头像高度
    let iconImageViewHeight:CGFloat = 45    //头像宽度
    let indicatorViewWidth:CGFloat = 25     //失败消息宽度
    let indicatorViewHeight:CGFloat = 25    //失败消息高度
    
    var iconContraintNotime: NSLayoutConstraint!
    var iconContraintWithTime: NSLayoutConstraint!
    
    //MARKS: 初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        //创建头像
        iconImageView = UIImageView(image: UIImage(named: "DefaultHead"))
        iconImageView.layer.cornerRadius = 8.0
        iconImageView.layer.masksToBounds = true
        iconImageView.tag = iconImageTag
        
        //创建背景图片
        backgroundImageView = UIImageView(image: backgroundImage.incoming, highlightedImage: backgroundImage.incomingHighlighed)
        backgroundImageView.userInteractionEnabled = true
        backgroundImageView.layer.cornerRadius = 5.0
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.tag = backgroundImageTag
        
        //创建时间
        timeLabel = UILabel(frame: CGRectZero)
        timeLabel.textAlignment = .Center
        timeLabel.font = timeFont
        
        //创建消息失败标识
        indicatorView = UIButton(type: .Custom)
        indicatorView.tag = indicatorTag
        indicatorView.setBackgroundImage(UIImage(named: "share_auth_fail"), forState: .Normal)
        indicatorView.hidden = true
        indicatorView.setTitleColor(UIColor.blackColor(), forState: .Normal)
        indicatorView.titleLabel?.font = indicatorFont
        
        //创建刷新标识
        
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(indicatorView)
        
        //禁止自动转换AutoresizingMask
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        //添加约束
        /*
         第一个参数:指定约束左边的视图view1
         第二个参数:指定view1的属性attr1，具体属性见文末。
         第三个参数:指定左右两边的视图的关系relation，具体关系见文末。
         第四个参数:指定约束右边的视图view2
         第五个参数:指定view2的属性attr2，具体属性见文末。
         第六个参数:指定一个与view2属性相乘的乘数multiplier
         第七个参数:指定一个与view2属性相加的浮点数constant
         这个函数的对照公式为:view1.attr1view2.attr2 * multiplier + constant
         如果设置的约束里不需要第二个view，要将第四个参数设为nil，第五个参数设为NSLayoutAttributeNotAnAttribute
         */
        //添加timeLabel约束,只需要x,y,父视图为toItem,相对于父视图右边10,左边10,顶部5
        contentView.addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -10))
        contentView.addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 5))
        
        //添加头像约束
        //相对于contentView左边10
        contentView.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
        
        //iconImageView高45,宽45
        iconImageView.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: iconImageViewWidth))
        iconImageView.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: iconImageViewHeight))
        
        //背景约束,相对于iconImageView右边10,上边1
        contentView.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Left, relatedBy: .Equal, toItem: iconImageView, attribute: .Right, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Top, relatedBy: .Equal, toItem: iconImageView, attribute: .Top, multiplier: 1, constant: 0))
        
        //消息标识约束,高17,宽17,中心点向右偏5,右边居中
        indicatorView.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: indicatorViewWidth))
        indicatorView.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: indicatorViewHeight))
        contentView.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .CenterY, relatedBy: .Equal, toItem: backgroundImageView, attribute: .CenterY, multiplier: 1, constant: -5))
        contentView.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .Left, relatedBy: .Equal, toItem: backgroundImageView, attribute: .Right, multiplier: 1, constant: 0))
        
        
        //没有带时间的约束,相对于contentView顶部10
        iconContraintNotime = NSLayoutConstraint(item: iconImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 10)
        
        //有带时间的约束,相对于timeLabel底部5
        iconContraintWithTime = NSLayoutConstraint(item: iconImageView, attribute: .Top, relatedBy: .Equal, toItem: timeLabel, attribute: .Bottom, multiplier: 1, constant: 5)
        
        contentView.addConstraint(iconContraintWithTime)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARKS: 当被重用的cell将要显示时，会调用这个方法
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.hidden = false
        contentView.addConstraint(iconContraintWithTime)
    }
    
    //MARKS: 发送消息
    func setMessage(message:ChatMessage){
        if !timeLabel.hidden {
            contentView.removeConstraint(iconContraintNotime)
            timeLabel.text = message.dataString
        } else {
            contentView.removeConstraint(iconContraintWithTime)
            contentView.addConstraint(iconContraintNotime)
        }
        
        if message.iconName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            if let image = UIImage(named: message.iconName) {
                iconImageView.image = image
            }
        }
        
        if message.incoming != (tag == receiveTag) {
            var layoutAttribute: NSLayoutAttribute
            var layoutConstraint: CGFloat
            var backlayoutAttribute: NSLayoutAttribute
            
            if message.incoming {
                tag = receiveTag
                backgroundImageView.image = backgroundImage.incoming
                backgroundImageView.highlightedImage = backgroundImage.incomingHighlighed
                layoutAttribute = .Left
                backlayoutAttribute = .Right
                layoutConstraint = 10
            } else {
                tag = sendTag
                backgroundImageView.image = backgroundImage.outgoing
                backgroundImageView.highlightedImage = backgroundImage.outgoingHighlighed
                layoutAttribute = .Right
                backlayoutAttribute = .Left
                layoutConstraint = -10
            }
            
            let constraints: NSArray = contentView.constraints
            
            // reAdd iconImageView left/right constraint
            let indexOfConstraint = constraints.indexOfObjectPassingTest { (constraint, idx, stop) in
                return (constraint.firstItem as! UIView).tag == iconImageTag && (constraint.firstAttribute == NSLayoutAttribute.Left || constraint.firstAttribute == NSLayoutAttribute.Right)
            }
            contentView.removeConstraint(constraints[indexOfConstraint] as! NSLayoutConstraint)
            contentView.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: layoutAttribute, relatedBy: .Equal, toItem: contentView, attribute: layoutAttribute, multiplier: 1, constant: layoutConstraint))
            
            // reAdd backgroundImageView left/right constraint
            let indexOfBackConstraint = constraints.indexOfObjectPassingTest { (constraint, idx, stop) in
                return (constraint.firstItem as! UIView).tag == backgroundImageTag && (constraint.firstAttribute == NSLayoutAttribute.Left || constraint.firstAttribute == NSLayoutAttribute.Right)
            }
            contentView.removeConstraint(constraints[indexOfBackConstraint] as! NSLayoutConstraint)
            contentView.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: layoutAttribute, relatedBy: .Equal, toItem: iconImageView, attribute: backlayoutAttribute, multiplier: 1, constant: layoutConstraint))
            
            // reAdd indicator left/right constraint
            let indexOfIndicatorConstraint = constraints.indexOfObjectPassingTest { (constraint, idx, stop) in
                return (constraint.firstItem as! UIView).tag == indicatorTag && (constraint.firstAttribute == NSLayoutAttribute.Left || constraint.firstAttribute == NSLayoutAttribute.Right)
            }
            contentView.removeConstraint(constraints[indexOfIndicatorConstraint] as! NSLayoutConstraint)
            contentView.addConstraint(NSLayoutConstraint(item: indicatorView, attribute: layoutAttribute, relatedBy: .Equal, toItem: backgroundImageView, attribute: backlayoutAttribute, multiplier: 1, constant: 0))
        }
    }
    
    //MARKS: 设置cell是否选中状态
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundImageView.highlighted = selected
    }
}

let backgroundImage = makeBackgroundImage()

func makeBackgroundImage() -> (incoming: UIImage, incomingHighlighed: UIImage, outgoing: UIImage, outgoingHighlighed: UIImage) {
    let maskOutgoing = UIImage(named: "SenderTextNodeBkg")!
    let maskOutHightedgoing = UIImage(named: "SenderTextNodeBkgHL")!
    let maskIncoming = UIImage(named: "ReceiverTextNodeBkg")!
    let maskInHightedcoming = UIImage(named: "ReceiverTextNodeBkgHL")!
    
    let incoming = maskIncoming.resizeImage()
    let incomingHighlighted = maskInHightedcoming.resizeImage()
    let outgoing = maskOutgoing.resizeImage()
    let outgoingHighlighted = maskOutHightedgoing.resizeImage()
    
    return (incoming, incomingHighlighted, outgoing, outgoingHighlighted)
}

func imageWithColor(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage! {
    let rect = CGRect(origin: CGPointZero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    CGContextSetRGBFillColor(context, red, green, blue, alpha)
    CGContextSetBlendMode(context, CGBlendMode.SourceAtop)
    CGContextFillRect(context, rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}
