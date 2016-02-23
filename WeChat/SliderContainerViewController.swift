//
//  SliderContainerViewController.swift
//  WeChat
//
//  Created by Smile on 16/2/17.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

@objc protocol SliderContainerViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
}

//侧边栏状态
enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

//主容器
class SliderContainerViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var mainViewController:UIViewController!//中间视图
    
    var leftViewController: UIViewController?//左侧边栏
    var rightViewController: UIViewController?//右侧边栏
    
    let mainPanelExpandedOffset: CGFloat = 80 //中间视图可见宽度
    var currentView:UIView?
    var baseView:UIView!
    var sliderDelegate:SliderContainerViewControllerDelegate?
    
    var needSwipeShowMenu:Bool = true//是否需要手势
    var panGestureRecognizer:UIPanGestureRecognizer?
    var panMovingLeft:Bool = false
    
    var startPanPoint:CGPoint = CGPointZero//滑动开始坐标点
    var leftViewShowWidth:CGFloat = 0
    var rightViewShowWidth:CGFloat = 0
    var sliderWidth:CGFloat = 0
    var mainWidth:CGFloat = 0
    
    var currentState: SlideOutState = .BothCollapsed {//初始状态
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForMainViewController(shouldShowShadow)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        self.leftViewShowWidth =  mainWidth - mainPanelExpandedOffset
        self.rightViewShowWidth = self.leftViewShowWidth
        
        addGestureRecognizer()
    }
    
    //MARKS: 添加手势
    func addGestureRecognizer(){
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pen:")
        panGestureRecognizer!.delegate = self
        if self.baseView == nil {
            self.baseView = self.view
        }
        
        self.sliderWidth = mainWidth / 2 - mainPanelExpandedOffset
        //self.baseView.addGestureRecognizer(panGestureRecognizer!)
        setNeedSwipeShowMenu()
    }
    
    func setNeedSwipeShowMenu(){
        if self.needSwipeShowMenu {
            baseView.addGestureRecognizer(panGestureRecognizer!)
        } else {
            baseView.removeGestureRecognizer(panGestureRecognizer!)
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == panGestureRecognizer) {
            //控制是否从视图的边缘触发弹出侧边试图
            if (gestureRecognizer.locationInView(currentView).x >= self.sliderWidth && gestureRecognizer.locationInView(currentView).x < currentView!.frame.size.width - self.sliderWidth) {
                return false
            }
            
            let panGesture = gestureRecognizer as! UIPanGestureRecognizer
            let translation = panGesture.translationInView(baseView)//指定的坐标系中移动
            //velocityInView 指定坐标系统中pan gesture拖动的速度
            if (panGesture.velocityInView(baseView).x < 600 && abs(translation.x) / abs(translation.y) > 1) {
                return true
            }
            
            return false
        }

        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceivePress press: UIPress) -> Bool {
        return false
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        /*let touchPoint = touch.locationInView(baseView)
        return CGRectContainsPoint(currentView!.frame, touchPoint)*/
        return true
    }
    
    //MARKS: 拦截下级视图的手势
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return false
    }
    
    //MARKS: 手势会传递到下级视图
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    //MARKS: 手势派发给下级视图
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    
    //MARKS: 手势事件
    func pen(gesture:UIPanGestureRecognizer){
        if panGestureRecognizer?.state == .Began {
            startPanPoint = (currentView?.frame.origin)!
            
            if currentView?.frame.origin.x == 0 {
                self.showShadowForMainViewController(true)
            }
            
            let point = gesture.velocityInView(baseView)
            if (point.x > 0) {
                if (currentView!.frame.origin.x >= 0 && leftViewController != nil) {
                    self.willShowSidePanelController(self.leftViewController!, isLeft: true)
                }
            } else if (point.x < 0) {
                if (currentView!.frame.origin.x <= 0 && rightViewController != nil) {
                    self.willShowSidePanelController(self.rightViewController!, isLeft: true)
                }
            }
            return;
        }
        
        let currentPostion = gesture.translationInView(baseView)
        var xOffPoint:CGFloat = startPanPoint.x + currentPostion.x
        
        if (xOffPoint > 0) {
            if (leftViewController != nil) {
                xOffPoint = xOffPoint > leftViewShowWidth ? leftViewShowWidth : xOffPoint;
            } else {
                xOffPoint = 0
            }
        } else if (xOffPoint < 0) {
            if (rightViewController != nil) {
                xOffPoint = xOffset < -rightViewShowWidth ? -rightViewShowWidth : xOffPoint;
            } else {
                xOffPoint = 0;
            }
        }
        if (xOffPoint != currentView!.frame.origin.x) {
           animateCenterPanelXPosition(xOffPoint)
        }
        
        if (panGestureRecognizer!.state == .Ended) {
            if (currentView!.frame.origin.x == 0) {
                self.showShadowForMainViewController(false)
            } else {
                if (panMovingLeft && currentView!.frame.origin.x > sliderWidth) {
                    self.toggleLeftPanel()
                } else if (!panMovingLeft && currentView!.frame.origin.x < -sliderWidth) {
                    self.toggleRightPanel()
                } else {
                    //向左滑动
                    if !panMovingLeft && (self.leftViewShowWidth - self.currentView!.frame.origin.x) < sliderWidth {
                        currentState = .BothCollapsed
                        self.toggleLeftPanel()
                    } else if (panMovingLeft && (self.leftViewShowWidth + self.currentView!.frame.origin.x) < sliderWidth){
                        currentState = .BothCollapsed
                        self.toggleRightPanel()
                    } else {
                        currentState = .LeftPanelExpanded
                        toggleLeftPanel()
                    }
                }
            }
        } else {
            let velocity = gesture.translationInView(baseView)
            if (velocity.x > 0) {
                panMovingLeft = true
            } else if (velocity.x < 0) {
                panMovingLeft = false
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        resetCurrentView()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    //MARKS: 重置当前currentView
    func resetCurrentView(){
        if currentView != mainViewController.view {
            var frame = CGRectZero
            var transform = CGAffineTransformIdentity
            if currentView == nil{
                frame = baseView.bounds
            } else {
                frame = currentView!.frame
                transform = currentView!.transform
            }
            
            currentView?.removeFromSuperview()
            currentView = mainViewController.view
            baseView.addSubview(currentView!)
            
            currentView?.transform = transform
            currentView?.frame = frame
        }
        
    }
    
    //MARKS: 初始化一些属性
    func initFrame(mainViewController:UIViewController,leftViewController:UIViewController?,rightViewController:UIViewController?){
        
        self.mainViewController = mainViewController
        
        if leftViewController != nil {
            self.leftViewController = leftViewController
        }
        
        if rightViewController != nil {
            self.rightViewController = rightViewController
        }
        
        self.baseView = self.view
        self.baseView.addSubview(self.mainViewController.view)
        
        //addChildViewController(self.mainViewController)
        //self.mainViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var xOffset:CGFloat = 0
    //MARKS: 显示左侧边栏
    func toggleLeftPanel() {
        if self.leftViewController == nil {
            return
        }
        
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
            xOffset = CGRectGetWidth(self.mainViewController.view.frame) - mainPanelExpandedOffset
        } else {
            xOffset = 0
        }
        
        animatePanel(shouldExpand: notAlreadyExpanded,state:.LeftPanelExpanded,xOffset: xOffset,isLeftToggle:true)
        
        if self.sliderDelegate != nil {
            self.sliderDelegate!.toggleLeftPanel!()
        }
    }
    
    //MARKS: 显示右侧边栏
    func toggleRightPanel() {
        if self.rightViewController == nil {
            return
        }
        
        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
            xOffset = -(CGRectGetWidth(self.mainViewController.view.frame) - mainPanelExpandedOffset)
        } else {
            xOffset = 0
        }
        
        animatePanel(shouldExpand: notAlreadyExpanded,state:.RightPanelExpanded,xOffset: xOffset,isLeftToggle:false)
        if self.sliderDelegate != nil {
            self.sliderDelegate!.toggleRightPanel!()
        }
    }
    
    //MARKS: 侧边栏动画
    func animatePanel(shouldExpand shouldExpand: Bool,state:SlideOutState,xOffset:CGFloat,isLeftToggle:Bool) {
        if (shouldExpand) {
            currentState = state
            animateCenterPanelXPosition(xOffset)
        } else {
            animateCenterPanelXPosition(0) { finished in
                self.currentState = .BothCollapsed
                if isLeftToggle {
                    self.leftViewController!.view.removeFromSuperview()
                }else {
                    self.rightViewController!.view.removeFromSuperview()
                }
            }
        }
    }
    
    //MARKS: 侧边栏动画
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.currentView!.frame = CGRectMake(targetPosition, self.baseView.bounds.origin.y, self.baseView.bounds.width, self.baseView.bounds.height)
            }, completion: completion)
    }
    
    //添加阴影
    func showShadowForMainViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            self.mainViewController.view.layer.shadowOpacity = 0.8
        } else {
            self.mainViewController.view.layer.shadowOpacity = 0.0
        }
    }
    
    
    //MARKS: 添加左侧边栏
    func addLeftPanelViewController(){
        willShowSidePanelController(leftViewController!,isLeft:true)
    }
    
    //MARKS: 添加右侧边栏
    func addRightPanelViewController(){
        willShowSidePanelController(rightViewController!,isLeft:false)
    }
    
    //MARKS: 添加视图
    func willShowSidePanelController(sliderPanelController: UIViewController,isLeft:Bool) {
        if isLeft {
            if leftViewController != nil {
                leftViewController!.view.frame = baseView.bounds
            }
        } else {
            if rightViewController != nil {
                rightViewController!.view.frame = baseView.bounds
            }
        }
        
        baseView.insertSubview(sliderPanelController.view, belowSubview: currentView!)
        
        if isLeft {
            if (self.rightViewController != nil && self.rightViewController!.view.superview != nil) {
                self.rightViewController!.view.removeFromSuperview()
            }
        } else {
            if (self.leftViewController != nil && self.leftViewController!.view.superview != nil) {
                self.leftViewController!.view.removeFromSuperview()
            }
        }
        //addChildViewController(sliderPanelController)
        //sliderPanelController.didMoveToParentViewController(self)
    }
}
