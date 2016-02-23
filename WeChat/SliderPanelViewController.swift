//
//  SliderPanelViewController.swift
//  WeChat
//
//  Created by Smile on 16/2/17.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//左右菜单
class SliderPanelViewController: UIViewController {
    
    var nagvHeight:CGFloat = 44//导航条高度
    var statusFrame:CGFloat = 0
    var top:CGFloat = 0
    var width:CGFloat = 0//导航条宽度
    var isLeft:Bool = true
    
    var leftPadding:CGFloat = 20
    var rightPadding:CGFloat = 10
    var topView:UIView!
    var topHeight:CGFloat = 100
    var topImage:CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFrame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createBackground(){
        let bgImageView = UIImageView()
        bgImageView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
        //拉伸图片底部
        var image = UIImage(named: "slider-bg")
        //image?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, bgImageView.frame.width, 650))
        image = image?.resizableImageWithCapInsets(UIEdgeInsetsMake(180, 0, 0,0), resizingMode: .Stretch)
        bgImageView.image = image
        
        self.view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
    }
    
    func initFrame(){
        statusFrame = UIApplication.sharedApplication().statusBarFrame.height
        top = statusFrame + nagvHeight
        
        width = self.view.frame.width - 80
        
        //交换左右padding
        if !isLeft{
            let padding = rightPadding
            leftPadding = rightPadding
            rightPadding = padding
        }
        
        createBackground()
        createHeader()
    }
    
    let topRightDimeWidth:CGFloat = 20
    func createHeader(){
        topView = UIView()
        topView.frame = CGRectMake(leftPadding, top, width - leftPadding - rightPadding, topHeight)
        
        let imageView = UIImageView(image: UIImage(named: "my-header"))
        imageView.frame = CGRectMake(0, 0, topImage, topImage)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        topView.addSubview(imageView)
        
        let label = UILabel()
        let labelHeight:CGFloat = 20
        let labelWidth:CGFloat = topView.frame.width - imageView.frame.width - topRightDimeWidth
        label.frame = CGRectMake(imageView.frame.width + 10, (topImage - labelHeight) / 2, labelWidth, labelHeight)
        label.text = "谁愿、许诺我一生"
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByTruncatingTail//有省略号
        label.font = UIFont(name: "AlNile-Bold", size: 20)
        topView.addSubview(label)
        
        self.view.addSubview(topView)
    }

}
