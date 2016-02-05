//
//  WeChatTabBarController.swift
//  WeChat
//
//  Created by Smile on 16/1/6.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class WeChatTabBarController: UITabBarController {

    var itemNameArray:[String] = ["message","contact","discover","me"]
    var itemNameSelectArray:[String] = ["message-touch","contact-touch","discover-touch","me-touch"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //MARKS: Load Controllers
        configTabBar()
        self.tabBar.showBadgeOnItemIndex(2)
    }
    
    func configTabBar() {
        var count:Int = 0;
        let items = self.tabBar.items!
        for item in items{
            var image:UIImage = UIImage(named: itemNameArray[count])!
            var selectedimage:UIImage = UIImage(named: itemNameSelectArray[count])!;
            image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
            selectedimage = selectedimage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
            item.selectedImage = selectedimage;
            item.image = image;
            //set font color for text #38ae31
            item.setTitleTextAttributes( [NSForegroundColorAttributeName: UIColor(red: 56/255, green: 174/255, blue: 49/255, alpha: 1)], forState: .Selected)
            count++;
        }
        
        
        self.selectedIndex = 0
    }
}
