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
    var pageControl:UIPageControl!
    //var images:[UIImage] = [UIImage]()
    var photos:[Photo] = [Photo]()
    //var delegate:WeChatCustomPhotoViewDelegate!
    var navigation:WeChatCustomNavigationHeaderView!
    var statusBarFrame:CGRect!
    var navigationBottom:WeChatCustomNavigationBottomView!
    var navigationHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarController!.tabBar.hidden = true
        initFrame()
        initNavigation()
    }
    
    func initFrame(){
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView = UIScrollView(frame:UIScreen.mainScreen().bounds)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.scrollsToTop = false
        self.scrollView.contentMode = .Center
        self.scrollView.maximumZoomScale = 2
        self.scrollView.zoomScale = 1.0
        self.scrollView.backgroundColor = UIColor.blackColor()
    
        addImages()
        self.view.addSubview(self.scrollView)
        createPageControl()
        
        //添加点击事件
        let tap = WeChatUITapGestureRecognizer(target: self, action: "viewTap:")
        self.scrollView.addGestureRecognizer(tap)
    }
    
    func viewTap(gestrue: WeChatUITapGestureRecognizer){
        UIView.animateWithDuration(0.5, delay:0.1,
            options:UIViewAnimationOptions.TransitionNone, animations:
            {
                ()-> Void in
                
                if self.navigation.frame.origin.y >= 0 {
                    //隐藏导航条
                    self.navigation.frame.origin = CGPoint(x: 0, y: -self.navigationHeight)
                    
                    //下移底部Label
                    self.navigationBottom.labelView?.frame.origin = CGPoint(x: 0, y: UIScreen.mainScreen().bounds.height - self.navigationBottom.labelView!.frame.height)
                    
                    //隐藏底部点赞
                    self.navigationBottom.bottomView.frame = CGRectMake(self.navigationBottom.bottomView.frame.origin.x, UIScreen.mainScreen().bounds.height, self.navigationBottom.bottomView.frame.width, 0)
                } else {
                    //隐藏导航条
                    self.navigation.frame.origin = CGPoint(x: 0, y: 0)
                    
                    //下移底部Label
                    self.navigationBottom.labelView?.frame.origin = CGPoint(x: 0, y: UIScreen.mainScreen().bounds.height - self.navigationBottom.labelView!.frame.height - self.navigationBottom.bottomHeight)
                    
                    //隐藏底部点赞
                    self.navigationBottom.bottomView.frame = CGRectMake(self.navigationBottom.bottomView.frame.origin.x, UIScreen.mainScreen().bounds.height - self.navigationBottom.bottomHeight, self.navigationBottom.bottomView.frame.width, self.navigationBottom.bottomHeight)
                }
            },
            completion:{
                (finished:Bool) -> Void in
                UIView.animateWithDuration(1, animations:{
                    ()-> Void in
                })
        })
        
    }
    
    //MARKS: 创建PageControl
    func createPageControl(){
        self.pageControl = UIPageControl()
        self.pageControl.frame = CGRectZero
        self.pageControl.numberOfPages = photos.count
        self.view.addSubview(self.pageControl)
    }
    
    //MARKS: 初始化导航条
    func initNavigation(){
        createNavigation()
    }
    
    func createNavigation(){
        createNavigationHeaderView()
        
        navigationBottom = WeChatCustomNavigationBottomView()
        navigationBottom.initData("时间，让深的，东西越来越深让浅的东西越来越浅。看的淡一点，伤的就会少一点，时间过了，爱情淡了，也就散了。别等不该等的人，别伤不该伤的心。我们真的要过了很久很久，才能够明白，自己真正怀念的，到底是怎样的人，怎样的事。",parentViewController: self)
        if navigationBottom.labelView != nil {
            self.view.addSubview(navigationBottom.labelView!)
            self.view.bringSubviewToFront(navigationBottom.labelView!)
        }
        
        self.view.addSubview(navigationBottom.bottomView)
        self.view.bringSubviewToFront(navigationBottom.bottomView)
        
        //添加点击事件
        let tap = WeChatUITapGestureRecognizer(target: self, action: "viewTap:")
        self.navigationBottom.labelView?.addGestureRecognizer(tap)
    }
    
    func createNavigationHeaderView(){
        self.navigationController?.navigationBar.hidden = true
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "MM月dd日 HH:mm"
        var sysTime = dateFormat.stringFromDate(NSDate())
        if photos.count > 1 {
            sysTime += "\n\(1)/\(photos.count)"
        }
        //获取状态栏
        statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.navigationHeight = self.navigationController!.navigationBar.bounds.height + statusBarFrame.height
        self.navigation = WeChatCustomNavigationHeaderView(frame: CGRectMake(0, 0,(self.navigationController?.navigationBar.bounds.width)!, navigationHeight), photoCount: 1, photoTotalCount: photos.count, backImage: UIImage(named: "back"), backTitle: "返回", centerLabel: sysTime, rightButtonText: "● ● ●", rightButtonImage: nil, backgroundColor: UIColor.darkGrayColor(),navigationController:self.navigationController!)
        self.view.addSubview(self.navigation)
        self.view.bringSubviewToFront(self.navigation)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigation.removeFromSuperview()
        createNavigationHeaderView()
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
        for(var i = 0;i < photos.count;i++){
            let photo = photos[i]
            //计算图片大小,确定其显示位置
            let image = photo.photoImage!
            let imageSize = image.size
            let bounds = UIScreen.mainScreen().bounds
            let width:CGFloat = bounds.width
            var height:CGFloat = 0
            let x:CGFloat = width * CGFloat(i)
            var y:CGFloat = 0
            //如果图片宽度>屏幕宽度
            /*if imageSize.width > bounds.width {
                width = bounds.width
            } else {
                width = imageSize.width
            }*/
            
            //如果图片的高度 > 屏幕高度
            if imageSize.height > bounds.height {
                height = bounds.height
            }else{
                height = imageSize.height
                //计算图片位置
                y = (bounds.height - imageSize.height) / 2
            }
            
            let imageView = UIImageView(frame: CGRectMake(x, y, width, height))
            imageView.image = image
            //设置图片自适应
            //imageView.contentMode = .ScaleAspectFill
            //imageView.autoresizesSubviews = true
            //imageView.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin,UIViewAutoresizing.FlexibleTopMargin,UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
            self.scrollView.addSubview(imageView)
            self.scrollView.sendSubviewToBack(imageView)
        }
        
        //为了让内容横向滚动，设置横向内容宽度为N个页面的宽度总和
        //不允许在垂直方向上进行滚动
        self.scrollView.contentSize = CGSizeMake(CGFloat(UIScreen.mainScreen().bounds.width * CGFloat(photos.count)), 0)
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.userInteractionEnabled = true
    }
    
    //MARKS: 缩放
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        for subview : AnyObject in scrollView.subviews {
            if subview.isKindOfClass(UIImageView) {
                return subview as? UIView
            }
        }
        
        return nil
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    //MARKS: 停止移动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
        let current:Int = Int(scrollView.contentOffset.x / UIScreen.mainScreen().bounds.size.width)
        //根据scrollView 的位置对page 的当前页赋值
        self.pageControl.currentPage = current
        
        self.navigation.resetTitle(current + 1)
        
        let x:CGFloat = CGFloat(current) * self.scrollView.frame.size.width;
        self.scrollView.contentOffset = CGPointMake(x, 0);
        
        //当显示到最后一页时，让滑动图消失
        if self.pageControl.currentPage == (photos.count - 1) {
            
        }
    }
}
