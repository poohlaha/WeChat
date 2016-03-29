//
//  WeChatChatViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/29.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//聊天窗口页面
class WeChatChatViewController: UIViewController,UITableViewDataSource, UITableViewDelegate , UITextViewDelegate {
    
    var tableView:UITableView!
    var toolBarView:WeChatChatToolBar!
    var recordIndicatorView: WeChatChatVoiceView!
    var videoController: WeChatChatVideoViewController!
    let toolBarMinHeight: CGFloat = 44.0
    
    var nagTitle:String!
    var nagHeight:CGFloat = 0//导航条高度
    var messageList = [ChatMessage]()
     var toolBarConstranit: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFrame()
    }
    
    //MARKS: 初始化
    func initFrame(){
        //MARKS: 设置导航行背景及字体颜色
        //WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.nagHeight = statusBarFrame.height + self.navigationController!.navigationBar.frame.height
        self.navigationItem.title = self.nagTitle
        self.view.backgroundColor = UIColor.whiteColor()
        initTableView()
    }
    
    //MARKS: 初始化tableView
    func initTableView(){
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.estimatedRowHeight = 44.0 //估算高度
        tableView.contentInset = UIEdgeInsetsMake(0, 0, toolBarMinHeight / 2, 0)//内边距
        tableView.separatorStyle = .None
        
        tableView.registerClass(WeChatChatTextCell.self, forCellReuseIdentifier: NSStringFromClass(WeChatChatTextCell))
        view.addSubview(tableView)
        
        toolBarView = WeChatChatToolBar(taget: self, voiceSelector: "voiceClick:", recordSelector: "recordClick:", emotionSelector: "emotionClick:", moreSelector: "moreClick:")
        toolBarView.textView.delegate = self
        view.addSubview(toolBarView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: toolBarMinHeight))
        toolBarConstranit = NSLayoutConstraint(item: toolBarView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(toolBarConstranit)
        
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBarView, attribute: .Top, multiplier: 1, constant: 0))
        
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapTableView:"))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hiddenMenuController:", name: UIMenuControllerWillHideMenuNotification, object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        /*if player != nil {
            if player.audioPlayer.playing {
                player.stopPlaying()
            }
        }*/
    }
    
    // show menuController
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: - tableView dataSource/Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: WeChatChatBaseCell?
        
        let message = messageList[indexPath.row]
        
        switch message.messageType {
        case .Text:
            cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(WeChatChatTextCell), forIndexPath: indexPath) as! WeChatChatTextCell
            break
        default:
            cell = nil
            break
            
        }
        
        // add gustureRecognizer to show menu items
        let action: Selector = "showMenuAction:"
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: action)
        doubleTapGesture.numberOfTapsRequired = 2
        
        cell!.backgroundImageView.addGestureRecognizer(doubleTapGesture)
        cell!.backgroundImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: action))
        cell!.backgroundImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "clickCellAction:"))
        
        if indexPath.row > 0 {
            let preMessage = messageList[indexPath.row - 1]
            if preMessage.dataString == message.dataString {
                cell!.timeLabel.hidden = true
            } else {
                cell!.timeLabel.hidden = false
            }
        }
        
        cell!.setMessage(message)
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func scrollToBottom() {
        let numberOfRows = tableView.numberOfRowsInSection(0)
        if numberOfRows > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }
    
    func reloadTableView() {
        let count = messageList.count
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: count - 1, inSection: 0)], withRowAnimation: .Top)
        tableView.endUpdates()
        scrollToBottom()
    }
    
    // MARK: scrollview delegate
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 2.0 {
            scrollToBottom()
            self.toolBarView.textView.becomeFirstResponder()
        } else if velocity.y < -0.1 {
            self.toolBarView.textView.resignFirstResponder()
        }
    }
    
    // MARK: - keyBoard notification
    func keyboardChange(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let newFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let animationTimer = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        view.layoutIfNeeded()
        if newFrame.origin.y == UIScreen.mainScreen().bounds.size.height {
            UIView.animateWithDuration(animationTimer, animations: { () -> Void in
                self.toolBarConstranit.constant = 0
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animateWithDuration(animationTimer, animations: { () -> Void in
                self.toolBarConstranit.constant = -newFrame.size.height
                self.scrollToBottom()
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    func showMenuAction(gestureRecognizer: UITapGestureRecognizer) {
        let twoTaps = (gestureRecognizer.numberOfTapsRequired == 2)
        let doubleTap = (twoTaps && gestureRecognizer.state == .Ended)
        let longPress = (!twoTaps && gestureRecognizer.state == .Began)
        
        if doubleTap || longPress {
            let pressIndexPath = tableView.indexPathForRowAtPoint(gestureRecognizer.locationInView(tableView))!
            tableView.selectRowAtIndexPath(pressIndexPath, animated: false, scrollPosition: .None)
            
            let menuController = UIMenuController.sharedMenuController()
            let localImageView = gestureRecognizer.view!
            
            menuController.setTargetRect(localImageView.frame, inView: localImageView.superview!)
            menuController.menuItems = [UIMenuItem(title: "复制", action: "copyAction:"), UIMenuItem(title: "转发", action: "transtionAction:"), UIMenuItem(title: "删除", action: "deleteAction:"), UIMenuItem(title: "更多", action: "moreAciton:")]
            
            menuController.setMenuVisible(true, animated: true)
        }
    }
    
    func copyAction(menuController: UIMenuController) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if let message = messageList[selectedIndexPath.row] as? TextMessage {
                UIPasteboard.generalPasteboard().string = message.text
            }
        }
    }
    
    // MARK: - gestureRecognizer
    func tapTableView(gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        toolBarConstranit.constant = 0
        toolBarView.showEmotion(false)
        toolBarView.showMore(false)
    }
    
    func hiddenMenuController(notifiacation: NSNotification) {
        if let selectedIndexpath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexpath, animated: false)
        }
        (notifiacation.object as! UIMenuController).menuItems = nil
    }
    
    func clickCellAction(gestureRecognizer: UITapGestureRecognizer) {
        let pressIndexPath = tableView.indexPathForRowAtPoint(gestureRecognizer.locationInView(tableView))!
        let pressCell = tableView.cellForRowAtIndexPath(pressIndexPath)
        let message = messageList[pressIndexPath.row]
        
        
    }
}


extension WeChatChatViewController{
    
    func voiceClick(button: UIButton) {
        if toolBarView.recordButton.hidden == false {
            toolBarView.showRecord(false)
        } else {
            toolBarView.showRecord(true)
            self.view.endEditing(true)
        }
    }
    
    // MARK: - textViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            let messageStr = textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if messageStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
                return true
            }
            
            let message = TextMessage(incoming: false, sentDate: NSDate(), iconName: "", text: messageStr)
            let receiveMessage = TextMessage(incoming: true, sentDate: NSDate(), iconName: "", text: messageStr)
            
            messageList.append(message)
            reloadTableView()
            messageList.append(receiveMessage)
            reloadTableView()
            //AudioServicesPlayAlertSound(messageOutSound)
            textView.text = ""
            return false
        }
        return true
    }
    
}
