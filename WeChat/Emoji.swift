//
//  Emoji.swift
//  WeChat
//
//  Created by Smile on 16/1/27.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//表情
struct WeChatEmoji{
    let image:UIImage
    let key:String
}

class Emoji {
    
    var emojiArray:[WeChatEmoji] = [WeChatEmoji]()
    
    var keys:[String] = [String]()
    
    init(){
        initKeys()
        for(var i = 1;i <= 100;i++){
            emojiArray.append(WeChatEmoji(image: UIImage(named: "Expression_\(i)")!, key: keys[i - 1]))
        }
    }
    
    func initKeys(){
        keys.append("[微笑]")
        keys.append("[撇嘴]")
        keys.append("[色]")
        keys.append("[发呆]")
        keys.append("[得意]")
        keys.append("[流泪]")
        keys.append("[害羞]")
        keys.append("[闭嘴]")
        keys.append("[睡]")
        keys.append("[大哭]")
        keys.append("[尴尬]")
        keys.append("[发怒]")
        keys.append("[调皮]")
        keys.append("[呲牙]")
        keys.append("[惊讶]")
        keys.append("[难过]")
        keys.append("[酷]")
        keys.append("[冷汗]")
        keys.append("[抓狂]")
        keys.append("[吐]")
        keys.append("[偷笑]")
        keys.append("[愉快]")
        keys.append("[白眼]")
        keys.append("[傲慢]")
        keys.append("[饥饿]")
        keys.append("[困]")
        keys.append("[惊恐]")
        keys.append("[流汗]")
        keys.append("[憨笑]")
        keys.append("[悠闲]")
        keys.append("[奋斗]")
        keys.append("[咒骂]")
        keys.append("[疑问]")
        keys.append("[嘘]")
        keys.append("[晕]")
        keys.append("[疯了]")
        keys.append("[衰]")
        keys.append("[骷髅]")
        keys.append("[敲打]")
        keys.append("[再见]")
        keys.append("[擦汗]")
        keys.append("[抠鼻]")
        keys.append("[鼓掌]")
        keys.append("[糗大了]")
        keys.append("[坏笑]")
        keys.append("[左哼哼]")
        keys.append("[右哼哼]")
        keys.append("[哈欠]")
        keys.append("[鄙视]")
        keys.append("[委屈]")
        keys.append("[快哭了]")
        keys.append("[阴险]")
        keys.append("[亲亲]")
        keys.append("[吓]")
        keys.append("[可怜]")
        keys.append("[菜刀]")
        keys.append("[西瓜]")
        keys.append("[啤酒]")
        keys.append("[篮球]")
        keys.append("[乒乓]")
        keys.append("[咖啡]")
        keys.append("[饭]")
        keys.append("[猪头]")
        keys.append("[玫瑰]")
        keys.append("[凋谢]")
        keys.append("[嘴唇]")
        keys.append("[爱心]")
        keys.append("[心碎]")
        keys.append("[蛋糕]")
        keys.append("[闪电]")
        keys.append("[炸弹]")
        keys.append("[刀]")
        keys.append("[足球]")
        keys.append("[瓢虫]")
        keys.append("[便便]")
        keys.append("[月亮]")
        keys.append("[太阳]")
        keys.append("[礼物]")
        keys.append("[拥抱]")
        keys.append("[强]")
        keys.append("[弱]")
        keys.append("[握手]")
        keys.append("[胜利]")
        keys.append("[抱拳]")
        keys.append("[勾引]")
        keys.append("[拳头]")
        keys.append("[差劲]")
        keys.append("[爱你]")
        keys.append("[NO]")
        keys.append("[OK]")
        keys.append("[爱情]")
        keys.append("[飞吻]")
        keys.append("[跳跳]")
        keys.append("[发抖]")
        keys.append("[怄火]")
        keys.append("[转圈]")
        keys.append("[磕头]")
        keys.append("[回头]")
        keys.append("[跳绳]")
        keys.append("[投降]")
    }
}
