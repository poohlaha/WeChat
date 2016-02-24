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
    
    var isShowGesture:Bool = true//是否显示手势
    
    var cellView:UIView!//scrollView
    var containtCellView: UIView!//scrollView中view
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
    
    //MARKS: 初始化
    init(style: UITableViewCellStyle, reuseIdentifier: String?,isShowGesture:Bool,leftPadding:CGFloat?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.isShowGesture = isShowGesture
        self.baseView = self.contentView
        self.userInteractionEnabled = true
        
        if leftPadding != nil {
            self.leftPadding = leftPadding!
        }
        initCellView()
    }
    
    deinit {
        if self.panGestureRecognizer != nil {
            self.panGestureRecognizer!.delegate = nil
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARKS: 初始化scrollView
    func initCellView(){
        self.cellView = UIView()
        self.cellView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containtCellView = UIView()
        self.cellView.addSubview(containtCellView)
        
        let cellSubViews = self.subviews
        insertSubview(cellView, atIndex: 0)
        for subView in cellSubViews {
            self.containtCellView.addSubview(subView)
        }
        
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
        //添加手势
        addGestureRecognizer()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellView.frame.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
    }
    
}


extension WeChatTableViewCell {
    
    func addGestureRecognizer(){
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
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [UIViewAnimationOptions.CurveEaseIn,UIViewAnimationOptions.CurveEaseOut], animations: {
            //self.cellView!.frame = CGRectMake(targetPosition, self.baseView.bounds.origin.y, self.baseView.bounds.width, self.baseView.bounds.height)
            self.cellViewRightConstraint.constant = -targetPosition
            self.cellViewLeftConstraint.constant = targetPosition
            self.layoutIfNeeded()
            }, completion: completion)
    }
    
    
    func cellPenGestureRecognizerDrag(gestureRecognizer:UIPanGestureRecognizer){
        switch(gestureRecognizer.state){
            case .Began:
                self.startPoint = gestureRecognizer.translationInView(self.cellView)
                self.startingLeftConstant = self.cellViewLeftConstraint.constant
                break
            
            case .Changed:
                let currentPoint:CGPoint = gestureRecognizer.translationInView(self.cellView)
                let deltaX:CGFloat = currentPoint.x - self.startPoint.x;
                
                var movingLeft:Bool = false
                if (currentPoint.x < self.startPoint.x) {  //1
                    movingLeft = true
                }
                
                /*if self.startingLeftConstant == 0 {
                    if (!movingLeft) {
                        let constant:CGFloat = max(-deltaX, 0); //3
                        if (constant == 0) { //4
                            //[self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO]; //5
                        } else {
                            self.cellViewLeftConstraint.constant = constant; //6
                        }
                    } else {
                        let constant = min(-deltaX, self.sliderLeftWidth); //7
                        if (constant == self.sliderLeftWidth) { //8
                            //[self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO]; //9
                        } else {
                            self.cellViewLeftConstraint.constant = constant; //10
                        }
                    }
                }*/
                
                
                if !movingLeft {//左滑动
                    var xOffPoint:CGFloat = startPoint.x + currentPoint.x
                    
                    if (xOffPoint > 0) {
                        xOffPoint = xOffPoint > self.sliderLeftWidth ? self.sliderLeftWidth : xOffPoint
                    } else if (xOffPoint < 0) {
                        
                    }
                    
                    animatePanelXPosition(xOffPoint,duration:0.5)
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
                
                break
            
            case .Cancelled:
                break
            
            default:
                break
        }
    }
}