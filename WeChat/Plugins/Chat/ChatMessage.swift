//
//  message.swift
//  LGChatViewController
//
//  Created by gujianming on 15/10/12.
//  Copyright © 2015年 jamy. All rights reserved.
//

import Foundation
import UIKit

enum ChatMessageType {
    case Text
    case Voice
    case Image
    case Video
}

class ChatMessage {
    let incoming: Bool
    let sentDate: NSDate
    var iconName: String
    
    var messageType: ChatMessageType {
        get {
            return ChatMessageType.Text
        }
    }
    
    let dataString: String = {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let date = NSDate()
        let formater = NSDateFormatter()
        formater.dateFormat = "MM-dd HH:mm"
        var dateStr: String = formater.stringFromDate(date)
        return dateStr
    }()
    
    init(incoming: Bool, sentDate: NSDate, iconName: String) {
        self.incoming = incoming
        self.sentDate = sentDate
        self.iconName = iconName
        // for test
        if incoming {
            self.iconName = "icon1"
        } else {
            self.iconName = "icon3"
        }
    }
}

class TextMessage: ChatMessage {
    let text: String
    override var messageType: ChatMessageType {
        get {
            return ChatMessageType.Text
        }
    }
    
    init(incoming: Bool, sentDate: NSDate, iconName: String, text: String) {
        self.text = text
        super.init(incoming: incoming, sentDate: sentDate, iconName: iconName)
    }
}


class VoiceMessage: ChatMessage {
    let voicePath: NSURL
    let voiceTime: NSNumber
    
    override var messageType: ChatMessageType {
        get {
            return ChatMessageType.Voice
        }
    }
    
    init(incoming: Bool, sentDate: NSDate, iconName: String, voicePath: NSURL, voiceTime: NSNumber) {
        self.voicePath = voicePath
        self.voiceTime = voiceTime
       super.init(incoming: incoming, sentDate: sentDate, iconName: iconName)
    }
}

class ImageMessage: ChatMessage {
    let image: UIImage
    override var messageType: ChatMessageType {
        get {
            return ChatMessageType.Image
        }
    }
    
    init(incoming: Bool, sentDate: NSDate, iconName: String, image: UIImage) {
        self.image = image
        super.init(incoming: incoming, sentDate: sentDate, iconName: iconName)
    }
}


class VideoMessage: ChatMessage {
    let url: NSURL
    
    override var messageType: ChatMessageType {
        get {
            return ChatMessageType.Video
        }
    }
    
    init(incoming: Bool, sentDate: NSDate, iconName: String, url: NSURL) {
        self.url = url
        super.init(incoming: incoming, sentDate: sentDate, iconName: iconName)
    }
}