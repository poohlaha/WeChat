//
//  WeChatTableViewCell.swift
//  WeChat
//
//  Created by Smile on 16/2/24.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

public enum WeChatCellStatus: Int {
    case Center = 1, Left, Right
}

//自定义tableViewCell,添加滑动手势
class WeChatTableViewCell:UITableViewCell {
    
    var cellView:SpringAnimation!
    var containtCellView: UIView!
    var cellStatus: WeChatCellStatus = .Center
    var layoutUpdating = false
    
    override var frame: CGRect {
        willSet {
            layoutUpdating = true
            let change = self.frame.size.width != newValue.size.width
            super.frame = newValue
            if change {
                self.layoutIfNeeded()
            }
        }
        didSet {
            layoutUpdating = false
        }
    }
    
    
    var panGestureRecognizer:UIPanGestureRecognizer?
    var startPoint:CGPoint = CGPointZero
    var sliderLeftWidth:CGFloat = 15
    var baseView:UIView!
    var cellViewRightConstraint:NSLayoutConstraint!//右边约束
    var cellViewLeftConstraint:NSLayoutConstraint!//左边约束
    var startingLeftConstant:CGFloat = 0
    var leftPadding:CGFloat = 0
    
    var rightWidth:CGFloat = 50//右侧不需要滑动宽度,用于显示右侧按钮
    
    //MARKS: 初始化
    
    deinit {
        self.panGestureRecognizer?.delegate = nil
        displayLink?.invalidate()
    }

    //MARKS: 添加Cell的滑动手势,主要用SpringAnimation
    func toggleView(subViewTags:[Int]){
        self.cellView = SpringAnimation(frame: CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.width - rightWidth, self.contentView.frame.height))
        self.cellView.translatesAutoresizingMaskIntoConstraints = false
        
        self.cellView.restCenter = CGPointMake(CGRectGetMidX(cellView.bounds), CGRectGetMidY(cellView.bounds))
        self.cellView.springConstant = 500
        self.cellView.dampingCoefficient = 15
        self.cellView.inheritsPanVelocity = false
        
        self.cellView.isRightMoving = true
        self.cellView.isLeftMoving = false
        self.cellView.isTopMoving = false
        self.cellView.isBottomMoving = false
        
        self.containtCellView = UIView(frame: self.cellView.frame)
        self.cellView.addSubview(containtCellView)
        
        let cellSubViews = self.subviews
        
        for subView in cellSubViews {
            print(subView.tag)
            if subViewTags.contains(subView.tag){
                self.containtCellView.addSubview(subView)
            }
        }
        
        self.cellView.addSubview(containtCellView)
        
        self.addSubview(cellView)
        //insertSubview(self.cellView, atIndex: 1)
        //self.cellView.backgroundColor = UIColor.greenColor()
        
        //添加手势
        //addGestureRecognizer()
        addSpringAnimation()
    }
    
    var displayLink:CADisplayLink?
    
    func addSpringAnimation(){
        self.displayLink = CADisplayLink(target: self, selector: "displayLinkTick:")
        self.displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: kCFRunLoopDefaultMode as String)
    }
    
    func displayLinkTick(link:CADisplayLink){
        self.cellView.simulateSpringWithDisplayLink(link)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // cellView.frame.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
    }
    
}


extension WeChatTableViewCell {
    
    func addGestureRecognizer(){
        self.baseView = self.contentView
        self.userInteractionEnabled = true
        
        //添加约束
        /*
        第一个参数 view1: 要设置的视图；
        第二个参数 attr1: view1要设置的属性；
        第三个参数 relation: 视图view1和view2的指定属性之间的关系;
        第四个参数 view2: 参照的视图；
        第五个参数 attr2: 参照视图view2的属性；
        第六个参数 multiplier: 视图view1的指定属性是参照视图view2制定属性的多少倍；
        第七个参数 c: 视图view1的指定属性需要加的浮点数
        */
        let leftConstraint = NSLayoutConstraint(item: cellView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
        self.cellViewLeftConstraint = leftConstraint
        
        let rightConstraint =  NSLayoutConstraint(item: cellView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
        self.cellViewRightConstraint = rightConstraint
        
        addConstraints([NSLayoutConstraint(item: cellView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0),
            leftConstraint,
            NSLayoutConstraint(item: cellView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0),
            rightConstraint])
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "cellPenGestureRecognizerDrag:")
        self.panGestureRecognizer!.delegate = self
        self.cellView.addGestureRecognizer(self.panGestureRecognizer!)
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer {
            let gesture = gestureRecognizer as! UIPanGestureRecognizer
            let translation = gesture.translationInView(gestureRecognizer.view)//返回在横坐标上、纵坐标上拖动了多少像素
            return fabs(translation.y) <= fabs(translation.x)//处理double类型的取绝对值
        } else {
            return true
        }
    }
    
    //MARKS: 禁止在某一点发生Gesture recognizers
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKindOfClass(UIPanGestureRecognizer.self) {
            let gesture = gestureRecognizer as! UIPanGestureRecognizer
            let velocity = gesture.velocityInView(gestureRecognizer.view).y//指定坐标系统中pan gesture拖动的速度
            return fabs(velocity) <= 0.20
        }
        
        return true
    }
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return !(touch.view!.isKindOfClass(UIControl.self))
    }
    
    
    //MARKS: 侧边栏动画
    func animatePanelXPosition(targetPosition: CGFloat,duration: NSTimeInterval, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(duration,
            delay: 0, // 动画延迟
            usingSpringWithDamping: 0.3,// 类似弹簧振动效果 0~1,数值越小「弹簧」的振动效果越明显。
            initialSpringVelocity: 10,//初始的速度，数值越大一开始移动越快。值得注意的是，初始速度取值较高而时间较短时，也会出现反弹情况
            options: [UIViewAnimationOptions.CurveEaseIn,UIViewAnimationOptions.CurveEaseOut],
            animations: {
            //self.cellView!.frame = CGRectMake(targetPosition, self.baseView.bounds.origin.y, self.baseView.bounds.width, self.baseView.bounds.height)
            self.cellViewRightConstraint.constant = -targetPosition
            self.cellViewLeftConstraint.constant = targetPosition
            self.layoutIfNeeded()
            }, completion: completion)
    }
    
    
    func animateXPosition(targetPosition: CGFloat,duration: NSTimeInterval) {
        /*let spring = CASpringAnimation(keyPath: "position.x")
        spring.damping = 5//阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
        spring.stiffness = 100//刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
        spring.mass = 1//质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
        spring.initialVelocity = -30//初始速率，动画视图的初始速度大小,速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
        spring.fromValue = self.cellView.layer.position.x
        spring.toValue = self.cellView.layer.position.x + targetPosition
        spring.duration = spring.settlingDuration
        self.cellView.layer.addAnimation(spring, forKey: spring.keyPath)*/
        
        UIView.animateWithDuration(1,
            delay: 0, // 动画延迟
            usingSpringWithDamping: 0.2,// 类似弹簧振动效果 0~1,数值越小「弹簧」的振动效果越明显。
            initialSpringVelocity: 20,//初始的速度，数值越大一开始移动越快。值得注意的是，初始速度取值较高而时间较短时，也会出现反弹情况,如果设置为0，表示忽略该属性，由动画持续时间和阻尼计算动画的效果。
            options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.cellViewRightConstraint.constant = -targetPosition
                self.cellViewLeftConstraint.constant = targetPosition
                NSThread.sleepForTimeInterval(0.1)
            }) { (Bool) -> Void in
                self.cellViewLeftConstraint.constant = -targetPosition
                self.cellViewRightConstraint.constant = targetPosition
        }
        
    }
    
    
    func cellPenGestureRecognizerDrag(gestureRecognizer:UIPanGestureRecognizer){
        switch(gestureRecognizer.state){
            case .Began:
                self.startPoint = gestureRecognizer.translationInView(self.cellView)
                self.startingLeftConstant = self.cellViewLeftConstraint.constant
                break
            
            case .Changed:
                let currentPoint:CGPoint = gestureRecognizer.translationInView(self.cellView)
                
                var movingLeft:Bool = false
                if (currentPoint.x < self.startPoint.x) {  //1
                    movingLeft = true
                }
                
                if !movingLeft {//左滑动
                    var xOffPoint:CGFloat = startPoint.x + currentPoint.x
                    
                    if (xOffPoint > 0) {
                        xOffPoint = xOffPoint > self.sliderLeftWidth ? self.sliderLeftWidth : xOffPoint
                    } else if (xOffPoint < 0) {
                        
                    }
                    
                    animateXPosition(xOffPoint, duration: 0.5)
                } else {//右滑动
                    
                }
                
                break
            
            case .Ended:
                if self.leftPadding > 0 {
                    animatePanelXPosition(-leftPadding,duration:0.3, completion: { (Bool) -> Void in
                        self.animatePanelXPosition(0,duration:0.1)
                    })
                } else {
                    animatePanelXPosition(0,duration:0.5)
                }
                
                //animateXPosition(0,duration:0.5)
                
                break
            
            case .Cancelled:
                break
            
            default:
                break
        }
    }
}