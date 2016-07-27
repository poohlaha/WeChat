//
//  WeChatChatAudioRecorder.swift
//  WeChat
//
//  Created by Smile on 16/3/29.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit
import AVFoundation

protocol WeChatChatAudioRecorderDelegate {
    func audioRecorderUpdateMetra(metra: Float)
}

let soundPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!

let audioSettings: [String: AnyObject] = [AVLinearPCMIsFloatKey: NSNumber(bool: false),
                                          AVLinearPCMIsBigEndianKey: NSNumber(bool: false),
                                          AVLinearPCMBitDepthKey: NSNumber(int: 16),
                                          AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM),//格式编码
                                          AVNumberOfChannelsKey: NSNumber(int: 1),//采集音轨,这里采用单声道
                                          AVSampleRateKey: NSNumber(int: 44100),//声音采样率
                                          AVEncoderAudioQualityKey: NSNumber(integer: AVAudioQuality.Medium.rawValue)//音频质量
                                          ]

//聊天录音
class WeChatChatAudioRecorder:NSObject, AVAudioRecorderDelegate {
    
    var audioData: NSData!
    var operationQueue: NSOperationQueue!
    var recorder: AVAudioRecorder!//录音
    
    var startTime: Double!
    var endTimer: Double!
    var timeInterval: NSNumber!
    var delegate:WeChatChatAudioRecorderDelegate?
    var totalTime:Double = 0
    
    convenience init(fileName: String) {
        self.init()
        
        let filePath = NSURL(fileURLWithPath: (soundPath as NSString).stringByAppendingPathComponent(fileName))
        
        recorder = try! AVAudioRecorder(URL: filePath, settings: audioSettings)
        recorder.delegate = self
        recorder.meteringEnabled = true
        
    }
    
    override init() {
        operationQueue = NSOperationQueue()
        super.init()
    }
    
    //MARKS: 开始录音
    func startRecord() {
        startTime = NSDate().timeIntervalSince1970
        performSelector("readyStartRecord", withObject: self, afterDelay: 0.5)//延迟执行
    }
    
    //MARKS:准备开始录音
    func readyStartRecord() {
        let audioSession = AVAudioSession.sharedInstance()//获取AVAudioSession类的实例,AVAudioSession是一个单例模式
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {
            NSLog("setCategory fail")
            return
        }
        
        do {
            try audioSession.setActive(true)
        } catch {
            NSLog("setActive fail")
            return
        }
        
        
        
        recorder.record()
        let operation = NSBlockOperation()
        operation.addExecutionBlock(updateMeters)
        operationQueue.addOperation(operation)
    }
    
    //MAKRS: 停止录音
    func stopRecord() {
        endTimer = NSDate().timeIntervalSince1970
        timeInterval = nil
        totalTime = endTimer - startTime
        if totalTime < 0.5 {
            //在0.5秒内取消执行函数，带的参数必须一样，才能取消成功
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "readyStartRecord", object: self)
        } else {
            timeInterval = NSNumber(int: NSNumber(double: recorder.currentTime).intValue)
            if timeInterval.intValue < 1 {
                performSelector("readyStopRecord", withObject: self, afterDelay: 0.4)
            } else {
                readyStopRecord()
            }
        }
        
        operationQueue.cancelAllOperations()
    }
    
    //MARKS:准备停止录音
    func readyStopRecord() {
        recorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false, withOptions: .NotifyOthersOnDeactivation)
        } catch {
            NSLog("readyStopRecord Error.")
        }
        
        audioData = NSData(contentsOfURL: recorder.url)
    }
    
    //MARKS: 发送updateMeters消息来刷新平均和峰值功率。此计数是以对数刻度计量的，-160表示完全安静，0表示最大输入值
    func updateMeters() {
        repeat {
            recorder.updateMeters()
            timeInterval = NSNumber(float: NSNumber(double: recorder.currentTime).floatValue)
            let averagePower = recorder.averagePowerForChannel(0)
            delegate?.audioRecorderUpdateMetra(averagePower)
            //NSThread.sleepForTimeInterval(0.2)
        } while(recorder.recording)
    }
    
    // MARK: audio delegate
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        NSLog("%@", (error?.localizedDescription)!)
    }
}