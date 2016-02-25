//
//  SpringAnimation.swift
//  WeChat
//
//  Created by Smile on 16/2/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//视图弹簧动画
class SpringAnimation: UIView,UIGestureRecognizerDelegate {

    var springEnabled:Bool = false
    var springConstant:CGFloat = 0//设置弹簧常数,Effectively, as you increase this, the speed at which the spring returns to rest increases
    var dampingCoefficient:CGFloat = 0//阻尼系数,Shouldn't be negative or you'll bounce off screen.
    var restCenter:CGPoint = CGPointZero//返回点
    var mass:CGFloat = 0
    var panDistanceLimits:UIEdgeInsets  = UIEdgeInsetsZero
    
    var panDragCoefficient:CGFloat = 0
    var inheritsPanVelocity:Bool = false//当为true时允许扔出View
    var panning:Bool{
        get {
            return (self.panGestureRecognizer?.state == UIGestureRecognizerState.Changed)
        }
    }
    
    var velocity:CGPoint = CGPointZero
    
    var leftAnchoredView:SpringAnimation?
    var rightAnchoredView:SpringAnimation?
    
    var panGestureRecognizer:UIPanGestureRecognizer?
    var pannedBlock:SpringLoadedViewPannedBlock?
    
    var isLeftMoving:Bool = true
    var isRightMoving:Bool = true
    var isTopMoving:Bool = true
    var isBottomMoving:Bool = true
    
    var sliderLeftWidth:CGFloat = 0//向右移动左边空的位置
    var sliderRightWidth:CGFloat = 0
    var sliderTopWidth:CGFloat = 0
    var sliderBottomWidth:CGFloat = 0
    
    var oldPoint:CGPoint = CGPointZero
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.springEnabled = true
        self.restCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.springConstant = 250
        self.dampingCoefficient = 20
        self.mass = 1
        self.panDistanceLimits = UIEdgeInsetsMake(CGFloat.max, CGFloat.max, CGFloat.max, CGFloat.max)
        self.panDragCoefficient = 1.0
        self.inheritsPanVelocity = false
        self.pannedBlock = nil
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "viewWasPanned:")
        self.addGestureRecognizer(panGestureRecognizer!)
        self.panGestureRecognizer?.delegate = self
        
        oldPoint = self.center
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func simulateSpringWithDisplayLink(displayLink:CADisplayLink){
        if self.springEnabled && !self.panning {
            for (var i = 0; i < displayLink.frameInterval; i++){
                let displacement:CGPoint = CGPointMake(self.center.x - self.restCenter.x,
                    self.center.y - self.restCenter.y)
                
                //控件收到的力
                let kx:CGPoint = CGPointMake(self.springConstant * displacement.x, self.springConstant * displacement.y)
                
                //控件受到的阻力
                let bv:CGPoint = CGPointMake(self.dampingCoefficient * self.velocity.x, self.dampingCoefficient * self.velocity.y)
                
                //加速度
                let acceleration:CGPoint = CGPointMake((kx.x + bv.x) / self.mass, (kx.y + bv.y) / self.mass)
                
                self.velocity.x -= (acceleration.x * CGFloat(displayLink.duration))
                self.velocity.y -= (acceleration.y * CGFloat(displayLink.duration))
                
                //设置控件新位置
                var newCenter:CGPoint = self.center
                //let oldCenter:CGPoint = self.center
                newCenter.x += (self.velocity.x * CGFloat(displayLink.duration))
                newCenter.y += (self.velocity.y * CGFloat(displayLink.duration))
                self.center = newCenter
            }
        }
    }
    
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer {
            let gesture = gestureRecognizer as! UIPanGestureRecognizer
            let translation = gesture.translationInView(gestureRecognizer.view)//返回在横坐标上、纵坐标上拖动了多少像素
            if !isLeftMoving {
                if translation.x < 0 {
                    return false
                }
            }
            
            if !isRightMoving {
                if translation.x > 0 {
                    return false
                }
            }
            
            if !isTopMoving {
                if translation.y < 0 {
                    return false
                }
            }
            
            if !isBottomMoving {
                if translation.y > 0 {
                    return false
                }
            }
            
            return fabs(translation.y) <= fabs(translation.x)//处理double类型的取绝对值
        } else {
            return true
        }
    }
    
    
    
    var startPoint:CGPoint = CGPointZero
    func viewWasPanned(sender:UIPanGestureRecognizer){
        switch(sender.state){
            case .Began:
                self.startPoint =  sender.translationInView(self)
                break
            
            case .Changed:
                var translation:CGPoint = CGPointApplyAffineTransform(sender.translationInView(self.superview),CGAffineTransformMakeScale(self.panDragCoefficient, self.panDragCoefficient))
                
                if !isLeftMoving {
                    if translation.x < 0 {
                        return
                    }
                }
                
                if !isRightMoving {
                    if translation.x > 0 {
                        return
                    }
                }
                
                if !isTopMoving {
                    if translation.y < 0 {
                        return
                    }
                }
                
                if !isBottomMoving {
                    if translation.y > 0 {
                        return
                    }
                }
                
                
               /* let translatedCenter:CGPoint = CGPointMake(self.center.x + translation.x, self.center.y + translation.y)
                
                if (translation.x > 0 && (translatedCenter.x - self.restCenter.x) > self.panDistanceLimits.right){
                    translation.x -= (translatedCenter.x - self.restCenter.x) - self.panDistanceLimits.right
                }
                else if (translation.x < 0 && (self.restCenter.x - translatedCenter.x) > self.panDistanceLimits.left){
                    translation.x += (self.restCenter.x - translatedCenter.x) - self.panDistanceLimits.left
                }
                
                if (translation.y > 0 && (translatedCenter.y - self.restCenter.y) > self.panDistanceLimits.bottom){
                    translation.y -= (translatedCenter.y - self.restCenter.y) - self.panDistanceLimits.bottom
                }
                else if (translation.y < 0 && (self.restCenter.y - translatedCenter.y) > self.panDistanceLimits.top){
                    translation.y += (self.restCenter.y - translatedCenter.y) - self.panDistanceLimits.top
                }*/
                
                if isRightMoving {
                    if self.sliderLeftWidth > 0 {
                        translation.x = self.sliderLeftWidth
                    }
                }
                
                if isLeftMoving {
                    if self.sliderRightWidth > 0 {
                        translation.x = -self.sliderRightWidth
                    }
                }
                
                if isTopMoving {
                    if self.sliderBottomWidth > 0 {
                        translation.y = -self.sliderBottomWidth
                    }
                }
                
                if isBottomMoving {
                    if self.sliderTopWidth > 0 {
                        translation.y = self.sliderTopWidth
                    }
                }
                
                self.center = CGPointMake(self.oldPoint.x + translation.x, self.oldPoint.y + translation.y)
                //self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y)
                
                sender.setTranslation(CGPointZero, inView: self)
                
                if ((self.pannedBlock) != nil) {
                    self.pannedBlock  = SpringLoadedViewPannedBlock(center: self.center, restCenter: self.restCenter, translation: translation, velocity: sender.velocityInView(self.superview), finished: false)
                }
                
                self.positionLeftAnchoredViewsWithRecognizer(sender)
                self.positionRightAnchoredViewsWithRecognizer(sender)
                
                break
            
            case .Ended:
                if (self.inheritsPanVelocity){
                    self.velocity = sender.velocityInView(self.superview)
                }
                break
            
            default:
                break
        }
        
        /*
        var translation:CGPoint = CGPointApplyAffineTransform(sender.translationInView(self.superview),CGAffineTransformMakeScale(self.panDragCoefficient, self.panDragCoefficient))
        
        let translatedCenter:CGPoint = CGPointMake(self.center.x + translation.x, self.center.y + translation.y)
        
        if (translation.x > 0 && (translatedCenter.x - self.restCenter.x) > self.panDistanceLimits.right){
            translation.x -= (translatedCenter.x - self.restCenter.x) - self.panDistanceLimits.right
        }
        else if (translation.x < 0 && (self.restCenter.x - translatedCenter.x) > self.panDistanceLimits.left){
            translation.x += (self.restCenter.x - translatedCenter.x) - self.panDistanceLimits.left
        }
        
        if (translation.y > 0 && (translatedCenter.y - self.restCenter.y) > self.panDistanceLimits.bottom){
            translation.y -= (translatedCenter.y - self.restCenter.y) - self.panDistanceLimits.bottom
        }
        else if (translation.y < 0 && (self.restCenter.y - translatedCenter.y) > self.panDistanceLimits.top){
            translation.y += (self.restCenter.y - translatedCenter.y) - self.panDistanceLimits.top
        }
        
        self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.superview)
        
        let finished:Bool = (sender.state == UIGestureRecognizerState.Ended)
        
        if (finished && self.inheritsPanVelocity){
            self.velocity = sender.velocityInView(self.superview)
        }
        
        if ((self.pannedBlock) != nil) {
            self.pannedBlock  = SpringLoadedViewPannedBlock(center: self.center, restCenter: self.restCenter, translation: translation, velocity: sender.velocityInView(self.superview), finished: finished)
        }
        
        self.positionLeftAnchoredViewsWithRecognizer(sender)
        self.positionRightAnchoredViewsWithRecognizer(sender)*/
    }
    
    
    func positionLeftAnchoredViewsWithRecognizer(recognizer:UIPanGestureRecognizer){
        if ((self.leftAnchoredView) != nil){
            var stopSpringing:Bool = false
            stopSpringing = (CGRectGetMinX(self.frame)  > (self.leftAnchoredView!.restCenter.x + self.leftAnchoredView!.bounds.size.width / 2))
            
            if (stopSpringing){
                var newFrame:CGRect = self.leftAnchoredView!.frame
                newFrame.origin.x = CGRectGetMinX(self.frame) - self.leftAnchoredView!.frame.size.width
                self.leftAnchoredView?.frame = newFrame
            }
            
            self.leftAnchoredView?.springEnabled = (!stopSpringing || recognizer.state == UIGestureRecognizerState.Ended)
            self.leftAnchoredView?.positionLeftAnchoredViewsWithRecognizer(recognizer)
        }
    }
    
    func positionRightAnchoredViewsWithRecognizer(recognizer:UIPanGestureRecognizer){
        if ((self.rightAnchoredView) != nil){
            var stopSpringing:Bool = false
            stopSpringing = (CGRectGetMaxX(self.frame) < (self.rightAnchoredView!.restCenter.x - self.rightAnchoredView!.bounds.size.width / 2))
            
            if (stopSpringing){
                var newFrame:CGRect = self.rightAnchoredView!.frame;
                newFrame.origin.x = CGRectGetMaxX(self.frame);
                self.rightAnchoredView?.frame = newFrame
            }
            
            self.rightAnchoredView?.springEnabled = (!stopSpringing || recognizer.state == UIGestureRecognizerState.Ended)
            self.rightAnchoredView?.positionRightAnchoredViewsWithRecognizer(recognizer)
        }
        
    }
}

struct SpringLoadedViewPannedBlock {
    var center:CGPoint = CGPointZero
    var restCenter:CGPoint = CGPointZero
    var translation:CGPoint = CGPointZero
    var velocity:CGPoint = CGPointZero
    var finished:Bool = false
}
