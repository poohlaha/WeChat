//
//  WeChatCustomPhotoView.swift
//  WeChat
//
//  Created by Smile on 16/1/20.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

protocol WeChatCustomPhotoViewDelegate {
    var images:[UIImage] { get set }
}

//自定义图片相册
class WeChatCustomPhotoView: UIViewController,UIScrollViewDelegate,UINavigationControllerDelegate {

    var scrollView:UIScrollView!
    //var images:[UIImage] = [UIImage]()
    var photos:[Photo] = [Photo]()
    //var delegate:WeChatCustomPhotoViewDelegate!
    var navigation:UINavigationController!
    var statusBarFrame:CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
        self.navigationController?.tabBarController!.tabBar.hidden = true
        initNavigation()
        
        //添加点击事件
        let tap = WeChatUITapGestureRecognizer(target: self, action: "viewTap:")
        self.view.addGestureRecognizer(tap)
    }
    
    func viewTap(gestrue: WeChatUITapGestureRecognizer){
        UIView.animateWithDuration(1, delay:0.1,
            options:UIViewAnimationOptions.TransitionNone, animations:
            {
                ()-> Void in
                
                /*if self.navigationController?.navigationBar.hidden == true {
                    self.navigationController?.navigationBar.hidden = false
                } else {
                    self.navigationController?.navigationBar.hidden = true
                }
                if self.navigationController?.view.frame.origin.y > 0 {
                    self.navigationController?.view.frame = CGRectMake(0, -(self.navigationController?.navigationBar.frame.height)!, (self.navigationController?.navigationBar.frame.width)!, (self.navigationController?.navigationBar.frame.height)!)
                } else {
                    self.navigationController?.view.frame = CGRectMake(0, (self.navigationController?.navigationBar.frame.height)!, (self.navigationController?.navigationBar.frame.width)!, (self.navigationController?.navigationBar.frame.height)!)
                }*/
                //self.navigationController?.navigationBar.alpha = 0.0;
            },
            completion:{
                (finished:Bool) -> Void in
                UIView.animateWithDuration(1, animations:{
                    ()-> Void in
                })
        })
        
    }
    
    func initFrame(){
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView = UIScrollView(frame:UIScreen.mainScreen().bounds)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.scrollsToTop = false
        self.scrollView.contentMode = .Center
        self.scrollView.maximumZoomScale = 2
        scrollView.backgroundColor = UIColor.blackColor()
        //delegate.images = self.images
        
        //为了让内容横向滚动，设置横向内容宽度为N个页面的宽度总和
        scrollView.contentSize = CGSizeMake(CGFloat(UIScreen.mainScreen().bounds.width * CGFloat(photos.count)), self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.scrollView.pagingEnabled = true
        addImages()
        self.view.addSubview(self.scrollView)
    }
    
    
    
    //MARKS: 初始化导航条
    func initNavigation(){
        //WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        //createTitle(1)
        createNavigation()
    }
    
    func createNavigation(){
        self.navigationController?.navigationBar.hidden = true
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "MM月dd日 HH:mm"
        var sysTime = dateFormat.stringFromDate(NSDate())
        if photos.count > 1 {
            sysTime += "\n\(1)/\(photos.count)"
        }
        
        //获取状态栏
        statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        let navigationHeight = self.navigationController!.navigationBar.bounds.height + statusBarFrame.height
        let navigation = WeChatCustomNavigationView(frame: CGRectMake(0, 0,(self.navigationController?.navigationBar.bounds.width)!, navigationHeight), photoCount: 1, photoTotalCount: photos.count, backImage: UIImage(named: "back"), backTitle: "返回", centerLabel: sysTime, rightButtonText: "● ● ●", rightButtonImage: nil, backgroundColor: UIColor.darkGrayColor(),navigationController:self.navigationController!)
        
        //self.navigationController?.view.addSubview(navigation)
        self.view.addSubview(navigation)
        self.view.bringSubviewToFront(navigation)
    }
    
    func createTitle(index:Int){
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "MM月dd日 HH:mm"
        var sysTime = dateFormat.stringFromDate(NSDate())
        if photos.count > 1 {
            sysTime += "\n\(index)/\(photos.count)"
        }
        
        self.navigationItem.title = sysTime
        //设置标题字体和颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont(name: "Arial-BoldMT", size: 15)!]
        
        //设置右侧按钮文字为三个点
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "● ● ●", style: UIBarButtonItemStyle.Plain, target: self, action: "rightBtnClick")
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont(name: "Arial-BoldMT", size: 10)!], forState: UIControlState.Normal)
    }
    
    func rightBtnClick(){
        
    }
    
    func addImages(){
        for photo in photos {
            //计算图片大小,确定其显示位置
            let image = photo.photoImage!
            let imageSize = image.size
            let bounds = UIScreen.mainScreen().bounds
            var width:CGFloat = 0
            var height:CGFloat = 0
            let x:CGFloat = 0
            var y:CGFloat = 0
            //如果图片宽度>屏幕宽度
            if imageSize.width >= bounds.width {
                width = bounds.width
            } else {
                width = imageSize.width
            }
            
            //如果图片的高度 > 屏幕高度
            if imageSize.height >= bounds.height {
                height = bounds.height
            }else{
                height = imageSize.height
                //计算图片位置
                y = (bounds.height - imageSize.height) / 2
            }
            
            let imageView = UIImageView(frame: CGRectMake(x, y, width, height))
            imageView.image = image
            //设置图片自适应
            imageView.contentMode = .ScaleAspectFill
            //imageView.autoresizesSubviews = true
            //imageView.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin,UIViewAutoresizing.FlexibleTopMargin,UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
            self.scrollView.addSubview(imageView)
        }
    }
    
    //MARKS: 缩放
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.scrollView.subviews[0]
    }
}
