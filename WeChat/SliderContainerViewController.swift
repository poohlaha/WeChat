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
    optional func collapseSidePanels()
}

//侧边栏状态
enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

//主容器
class SliderContainerViewController: UIViewController,SliderContainerViewControllerDelegate {
    
    var mainViewController:UIViewController!//中间视图
    var weChatNavigationController:UINavigationController!//导航,用于包含中间视图
    
    var leftViewController: UIViewController?//左侧边栏
    var rightViewController: UIViewController?//右侧边栏
    
    let mainPanelExpandedOffset: CGFloat = 60 //中间视图可见宽度
    var currentView:UIView?
    var baseView:UIView!
    
    var currentState: SlideOutState = .BothCollapsed {//初始状态
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        resetCurrentView()
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
        
        if self.leftViewController == nil && self.rightViewController == nil {
            return
        }
        
        self.baseView = self.view
        self.baseView.addSubview(self.mainViewController.view)
        //addChildViewController(self.mainViewController)
        //self.mainViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARKS: 显示左侧边栏
    func toggleLeftPanel() {
        if self.leftViewController == nil {
            return
        }
        
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        animatePanel(shouldExpand: notAlreadyExpanded,state:.LeftPanelExpanded,xOffset: CGRectGetWidth(self.mainViewController.view.frame) - mainPanelExpandedOffset,isLeftToggle:true)
    }
    
    //MARKS: 显示右侧边栏
    func toggleRightPanel() {
        if self.rightViewController == nil {
            return
        }
        
        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        let xOffset:CGFloat = -(CGRectGetWidth(self.mainViewController.view.frame) - mainPanelExpandedOffset)
        animatePanel(shouldExpand: notAlreadyExpanded,state:.RightPanelExpanded,xOffset: xOffset,isLeftToggle:false)
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
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            self.mainViewController.view.layer.shadowOpacity = 0.8
        } else {
            self.mainViewController.view.layer.shadowOpacity = 0.0
        }
    }
    
    
    //MARKS: 添加左侧边栏
    func addLeftPanelViewController(){
        leftViewController!.view.frame = baseView.bounds
        addChildSidePanelController(leftViewController!)
        if (self.rightViewController != nil && self.rightViewController!.view.superview != nil) {
            self.rightViewController!.view.removeFromSuperview()
        }
    }
    
    //MARKS: 添加右侧边栏
    func addRightPanelViewController(){
        rightViewController!.view.frame = baseView.bounds
        addChildSidePanelController(rightViewController!)
        if (self.leftViewController != nil && self.leftViewController!.view.superview != nil) {
            self.leftViewController!.view.removeFromSuperview()
        }
    }
    
    //MARKS: 添加视图
    func addChildSidePanelController(sliderPanelController: UIViewController) {
        baseView.insertSubview(sliderPanelController.view, belowSubview: currentView!)
        //addChildViewController(sliderPanelController)
        //sliderPanelController.didMoveToParentViewController(self)
    }
}
