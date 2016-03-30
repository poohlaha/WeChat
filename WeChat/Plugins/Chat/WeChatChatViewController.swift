//
//  WeChatChatViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/29.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit
import AVFoundation

let messageOutSound: SystemSoundID = {
    var soundID: SystemSoundID = 10120
    let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "MessageOutgoing", "aiff", nil)
    AudioServicesCreateSystemSoundID(soundUrl, &soundID)
    return soundID
}()


let messageInSound: SystemSoundID = {
    var soundID: SystemSoundID = 10121
    let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "MessageIncoming", "aiff", nil)
    AudioServicesCreateSystemSoundID(soundUrl, &soundID)
    return soundID
}()


//聊天窗口页面
class WeChatChatViewController: UIViewController,UITableViewDataSource, UITableViewDelegate , UITextViewDelegate {
    
    var tableView:UITableView!
    var toolBarView:WeChatChatToolBar!
    var recordIndicatorView: WeChatChatRecordIndicatorView!
    var recordIndicatorCancelView:WeChatChatRecordIndicatorCancelView?
    var videoController: WeChatChatVideoViewController!
    let toolBarMinHeight: CGFloat = 50
    let indicatorViewH: CGFloat = 150
    
    var nagTitle:String!
    var nagHeight:CGFloat = 0//导航条高度
    var messageList = [ChatMessage]()
    var toolBarConstranit: NSLayoutConstraint!
    
    var recorder: WeChatChatAudioRecorder!
    var player: WeChatChatAudioPlayer!
    var shortView:WeChatChatRecordShortView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFrame()
    }
    
    //MARKS: 初始化
    func initFrame(){
        //MARKS: 设置导航行背景及字体颜色
        //WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        
        //解决录音时touchDown事件影响
        self.navigationController!.interactivePopGestureRecognizer!.delaysTouchesBegan = false
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.nagHeight = statusBarFrame.height + self.navigationController!.navigationBar.frame.height
        self.navigationItem.title = self.nagTitle
        self.view.backgroundColor = UIColor.whiteColor()
        initTableView()
        initToolBar()
        initRecordIndicatorView()
        addConstraints()
    }
    
    //MARKS: 添加约束
    func addConstraints(){
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: toolBarView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: toolBarMinHeight))
        toolBarConstranit = NSLayoutConstraint(item: toolBarView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(toolBarConstranit)
        
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBarView, attribute: .Top, multiplier: 1, constant: 0))
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hiddenMenuController:", name: UIMenuControllerWillHideMenuNotification, object: nil)
    }
    
    //MARKS: 初始化toolBar
    func initToolBar(){
        toolBarView = WeChatChatToolBar(taget: self, voiceSelector: "voiceClick:", recordSelector: "recordClick:", emotionSelector: "emotionClick:", moreSelector: "moreClick:")
        toolBarView.textView.delegate = self
        view.addSubview(toolBarView)
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
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
        tableView.registerClass(WeChatChatVoiceCell.self, forCellReuseIdentifier: NSStringFromClass(WeChatChatVoiceCell))
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapTableView:"))
    }
    
    func initRecordIndicatorView(){
        recordIndicatorView = WeChatChatRecordIndicatorView(frame: CGRectMake(self.view.center.x - indicatorViewH / 2, self.view.center.y - indicatorViewH / 3, indicatorViewH, indicatorViewH))
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if player != nil {
            if player.audioPlayer.playing {
                player.stopPlaying()
            }
        }
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
        case .Voice:
            cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(WeChatChatVoiceCell), forIndexPath: indexPath) as! WeChatChatVoiceCell
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
    
    //MARKS: 复制
    func copyAction(menuController: UIMenuController) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if let message = messageList[selectedIndexPath.row] as? TextMessage {
                UIPasteboard.generalPasteboard().string = message.text
            }
        }
    }
    
    //MARKS: 转发
    func transtionAction(menuController: UIMenuController) {
        NSLog("转发")
    }
    
    //MARKS: 删除
    func deleteAction(menuController: UIMenuController) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            messageList.removeAtIndex(selectedIndexPath.row)
            tableView.reloadData()
        }
    }
    
    //MARKS: 更多
    func moreAciton(menuController: UIMenuController) {
        NSLog("click more")
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
        
        if message.messageType == .Voice {
            let message = message as! VoiceMessage
            let cell = pressCell as! WeChatChatVoiceCell
            let play = WeChatChatAudioPlayer()
            player = play
            player.startPlaying(message)
            cell.beginAnimation()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(message.voiceTime.intValue) * 1000 * 1000 * 1000), dispatch_get_main_queue(), { () -> Void in
                cell.stopAnimation()
            })
        } else if message.messageType == .Video {
            let message = message as! VideoMessage
            if videoController != nil {
                videoController = nil
            }
            videoController = WeChatChatVideoViewController()
            videoController.setPlayUrl(message.url)
            presentViewController(videoController, animated: true, completion: nil)
        }
    }
}


extension WeChatChatViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate,WeChatChatAudioRecorderDelegate{
    
    //MARKS: 点击左边图片事件
    func voiceClick(button: UIButton) {
        if toolBarView.recordButton.hidden == false {
            toolBarView.showRecord(false)
        } else {
            toolBarView.showRecord(true)
            self.view.endEditing(true)
        }
    }
    
    //marks: 语音按住speak
    func recordClick(button: UIButton) {
        button.setTitle(talkButtonHightedMessage, forState: .Normal)
        button.addTarget(self, action: "recordComplection:", forControlEvents: .TouchUpInside)
        button.addTarget(self, action: "recordDragOut:", forControlEvents: .TouchDragOutside)
        button.addTarget(self, action: "recordDragIn:", forControlEvents: .TouchDragInside)
        button.addTarget(self, action: "recordCancel:", forControlEvents: .TouchUpOutside)
        button.addTarget(self, action: "recordDragExit:", forControlEvents: .TouchDragExit)
        button.addTarget(self, action: "recordDragEnter:", forControlEvents: .TouchDragEnter)
        
        let currentTime = NSDate().timeIntervalSinceReferenceDate
        let record = WeChatChatAudioRecorder(fileName: "\(currentTime).wav")
        record.delegate = self
        recorder = record
        recorder.startRecord()
        
        recordIndicatorView = WeChatChatRecordIndicatorView(frame: CGRectMake(self.view.center.x - indicatorViewH / 2, self.view.center.y - indicatorViewH / 3, indicatorViewH, indicatorViewH))
        view.addSubview(recordIndicatorView)
    }
    
    //MARKS: 从控件窗口之外拖动到内部
    func recordDragEnter(button: UIButton){
        button.setTitle(talkButtonHightedMessage, forState: .Normal)
        recorder.startRecord()
        if recordIndicatorCancelView != nil {
            recordIndicatorCancelView?.removeFromSuperview()
        }
        //recordIndicatorView.showText(talkMessage, textColor: UIColor.whiteColor())
        view.addSubview(recordIndicatorView)
    }
    
    //MARKS: 手指在控件上拖动
    func recordDragIn(button: UIButton){
       
    }
    
    
    //MARKS: 控件窗口内部拖动到外部
    func recordDragExit(button: UIButton){
        button.setTitle(talkButtonHightedMessage, forState: .Normal)
        recorder.stopRecord()
        recordIndicatorView.removeFromSuperview()
        
        createCancelView()
        view.addSubview(recordIndicatorCancelView!)
    }
    
    func createCancelView(){
        if recordIndicatorCancelView == nil {
            recordIndicatorCancelView = WeChatChatRecordIndicatorCancelView(frame: CGRectMake(self.view.center.x - indicatorViewH / 2, self.view.center.y - indicatorViewH / 3, indicatorViewH, indicatorViewH))
        }
    }
    
    //MARKS: speak完成
    func recordComplection(button: UIButton) {
        button.setTitle(talkButtonDefaultMessage, forState: .Normal)
        recorder.stopRecord()
        recorder.delegate = nil
        recordIndicatorView.removeFromSuperview()
        recordIndicatorView = nil
        
        if recorder.timeInterval != nil {
            let message = VoiceMessage(incoming: false, sentDate: NSDate(), iconName: "", voicePath: recorder.recorder.url, voiceTime: recorder.timeInterval)
            let receiveMessage = VoiceMessage(incoming: true, sentDate: NSDate(), iconName: "", voicePath: recorder.recorder.url, voiceTime: recorder.timeInterval)
            
            if recorder.timeInterval.intValue > 0 {
                messageList.append(message)
                reloadTableView()
                messageList.append(receiveMessage)
                reloadTableView()
                AudioServicesPlayAlertSound(messageOutSound)
            } else {//时间太短,弹出对话框
                createShortView()
                self.view.addSubview(self.shortView!)
                performSelector("readyToRemoveShorView", withObject: self, afterDelay: 0.2)
            }
            
        }else{
            createShortView()
            self.view.addSubview(self.shortView!)
            performSelector("readyToRemoveShorView", withObject: self, afterDelay: 0.2)
        }
    }
    
    //MARKS: 移除shortView
    func readyToRemoveShorView(){
        self.shortView?.removeFromSuperview()
    }
    
    //MARKS: 说话时间太短
    func createShortView(){
        if self.shortView == nil {
            self.shortView = WeChatChatRecordShortView(frame: CGRectMake(self.view.center.x - indicatorViewH / 2, self.view.center.y - indicatorViewH / 3, indicatorViewH, indicatorViewH))
        }
    }
    
    //MARKS: 触摸在控件外拖动时
    func recordDragOut(button: UIButton) {
        button.setTitle(talkButtonDefaultMessage, forState: .Normal)
        recorder.stopRecord()
        
        createCancelView()
        view.addSubview(recordIndicatorCancelView!)
    }
    
    //MARKS: speak取消
    func recordCancel(button: UIButton) {
        button.setTitle(talkButtonDefaultMessage, forState: .Normal)
        recorder.stopRecord()
        recorder.delegate = nil
        recordIndicatorView.removeFromSuperview()
        recordIndicatorView = nil
        
        recordIndicatorCancelView?.removeFromSuperview()
        recordIndicatorCancelView = nil
    }
    
    // MARK: -WeChatChatAudioRecorderDelegate
    func audioRecorderUpdateMetra(metra: Float) {
        if recordIndicatorView != nil {
            recordIndicatorView.updateLevelMetra(metra)
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
            AudioServicesPlayAlertSound(messageOutSound)
            textView.text = ""
            return false
        }
        return true
    }
    
}
