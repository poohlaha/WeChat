//
//  FirstStartViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//启动向导页面
class WeChatFirstStartViewController: UIViewController,UIScrollViewDelegate {
    
    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    var pages:Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createScrollView()
    }
    
    func createScrollView(){
        self.scrollView = UIScrollView()
        self.scrollView.frame = self.view.bounds
        self.scrollView.delegate = self
        //为了让内容横向滚动，设置横向内容宽度为N个页面的宽度总和
        //不允许在垂直方向上进行滚动
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * CGFloat(pages),self.view.frame.size.height)
        self.scrollView.pagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.scrollsToTop = false
        self.scrollView.backgroundColor = UIColor.blackColor()
        
        for i in 0 ..< pages {
            let imageView = UIImageView(image: UIImage(named: "news\(i)")!)
            imageView.frame=CGRectMake(self.view.frame.size.width * CGFloat(i),CGFloat(0),
                                     self.view.frame.size.width,self.view.frame.size.height)
            self.scrollView.addSubview(imageView)
            self.scrollView.sendSubviewToBack(imageView)
        }
        
        
        scrollView.contentOffset = CGPointZero
        scrollView.userInteractionEnabled = true
        self.view.addSubview(scrollView)
        
        createPageControl()
    }
    
    //MARKS: 创建PageControl
    func createPageControl(){
        self.pageControl = UIPageControl()
        self.pageControl.frame = CGRectZero
        self.pageControl.numberOfPages = pages
        self.view.addSubview(self.pageControl)
    }
    
    //MARKS: 停止移动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
        let current:Int = Int(scrollView.contentOffset.x / UIScreen.mainScreen().bounds.size.width)
        //根据scrollView 的位置对page 的当前页赋值
        self.pageControl.currentPage = current
        
        let x:CGFloat = CGFloat(current) * self.scrollView.frame.size.width;
        self.scrollView.contentOffset = CGPointMake(x, 0);
        
        //当显示到最后一页时
        if self.pageControl.currentPage == (pages - 1) {
            
        }
    }
}
