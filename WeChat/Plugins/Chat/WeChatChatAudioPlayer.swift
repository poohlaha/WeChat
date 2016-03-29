//
//  WeChatChatAudioPlayer.swift
//  WeChat
//
//  Created by Smile on 16/3/29.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit
import AVFoundation

//播放录音
class WeChatChatAudioPlayer: NSObject, AVAudioPlayerDelegate {

    
    var audioPlayer: AVAudioPlayer!
    
    func startPlaying(message: VoiceMessage) {
        if (audioPlayer != nil && audioPlayer.playing) {
            stopPlaying()
        }
        
        let voiceData = NSData(contentsOfURL: message.voicePath)
        
        do {
            try audioPlayer = AVAudioPlayer(data: voiceData!)
        } catch{
            return
        }
        audioPlayer.delegate = self
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            // no-op
        }
        
        audioPlayer.play()
    }
    
    
    func stopPlaying() {
        audioPlayer.stop()
    }
}
