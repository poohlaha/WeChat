//
//  DiscoverScanViewController.swift
//  WeChat
//
//  Created by Smile on 16/7/19.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit
import AVFoundation

//扫一扫功能,使用AVFoundation框架,需要实现AVCaptureMetadataOutputObjectsDelegate协议
class ScanViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    //MARKS: 会话
    var captureSession:AVCaptureSession!
    //MARKS: 扑捉图像
    var videoPreviewLayer:AVCaptureVideoPreviewLayer!
    //MARKS: 二维码图层
    var qrCodeFrameView:UIView?
    //MARKS: 设备
    var captureDevice:AVCaptureDevice!
    //MARKS: 输入设备
    var captureInput:AVCaptureInput!
    //MARKS: 输出设备
    var captureMetaOutput:AVCaptureMetadataOutput!
    //MARKS: 扫描滚动条
    var line: UIImageView!
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    let screenSize = UIScreen.mainScreen().bounds.size
    
    var traceNumber = 0
    var upORdown = false
    var timer:NSTimer!
    
    var isSecurity:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置标题
        self.title = "二维码扫描"
        
        if !initSetting() {
            isSecurity = false
            return
        }
        
        if !initCamera() {
            return
        }
        
        initScanLine()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isSecurity {
            captureSession.startRunning()//调用视频捕获回话的startRunning方法来启动
            timer = NSTimer(timeInterval: 0.02, target: self, selector: #selector(ScanViewController.scanLineAnimation), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        if isSecurity {
            traceNumber = 0
            upORdown = false
            captureSession.stopRunning()
            timer.invalidate()
            timer = nil
        }
        
        super.viewWillDisappear(animated)
    }
    
    //MARKS: 初始化相机设备
    //MARKS: 二维码的读取完全是基于视频捕获的，那么为了实时捕获视频，我们只需要以合适的AVCaptureDevice对象作为输入参数去实例化一个AVCaptureSession对象
    func initCamera() -> Bool{
        //捕获视频数据
        captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        //以视频设备为输入参数去实例化了一个AVCaptureSession会话，用它来实现实时视频捕获
        do {
            captureInput = try AVCaptureDeviceInput(device: captureDevice)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
        
        //输出端
        captureMetaOutput = AVCaptureMetadataOutput()
        //设置代理,GCD的串行执行队列
        captureMetaOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetaOutput.rectOfInterest = makeScanReaderInterestRect()
        
        
        //AVCaptureSession会话是用来管理视频数据流从输入设备传送到输出端的会话过程的。
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetHigh//高质量采集率
        
        //添加输入输出设备
        if captureSession.canAddInput(captureInput){
            captureSession.addInput(captureInput)
        }
        
        if captureSession.canAddOutput(captureMetaOutput){
            captureSession.addOutput(captureMetaOutput)
        }
        
         //metadataObjectTypes属性也非常重要，因为它的值会被用来判定整个应用程序对哪类元数据感兴趣
        captureMetaOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
        
        
        //显示摄像头捕获到的图像
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = view.bounds
        
        //设置扫描区域界面
        
        self.view.layer.insertSublayer(videoPreviewLayer, atIndex: 0)
        self.view.addSubview(makeScanCameraShadowView(makeScanReaderRect()))
        self.view.addSubview(makeScanView())
        
        return true
    }
    
    func makeScanView() -> UIView{
        let rect:CGRect = makeScanReaderRect()
        let labelTotalHeight:CGFloat = 50
        let rectView = UIView()
        rectView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + labelTotalHeight)
        
        let labelTopPadding:CGFloat = 20
        let labelView = makeView(CGRectMake(0, rect.size.height + labelTopPadding, rect.size.width, labelTotalHeight), labelTopPadding: labelTopPadding)
        rectView.addSubview(labelView)
        return rectView
    }
    
    func makeView(rect:CGRect,labelTopPadding:CGFloat) -> UIView{
        let view = UIView(frame: rect)
        let labelHeight:CGFloat = 10
        
        let label1 = createLabel(CGRectMake(0, 0, rect.width, labelHeight), string: "将二维码/条码放入框内，即可自动扫描", color: UIColor.whiteColor(), fontName: "AlNile", fontSize: 16)
        view.addSubview(label1)
        
        let label2 = createLabel(CGRectMake(0, labelHeight + labelTopPadding, rect.width, labelHeight), string: "我的二维码", color: UIColor.greenColor(), fontName: "AlNile", fontSize: 16)
        view.addSubview(label2)
        return view
    }
    
    func createLabel(frame:CGRect,string:String,color:UIColor,fontName:String,fontSize:CGFloat) -> UILabel{
        let label = UILabel(frame: frame)
        label.textAlignment = .Center
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = color
        label.numberOfLines = 1
        label.text = string
        return label
    }
    
    //MARKS: 设置扫描线条
    func initScanLine(){
        let rect = makeScanReaderRect()
        
        var imageSize: CGFloat = 20.0
        let imageX = rect.origin.x
        let imageY = rect.origin.y
        let width = rect.size.width
        let height = rect.size.height + 2
        
        /// 四个边角
        let imageViewTL = UIImageView(frame: CGRectMake(imageX, imageY, imageSize, imageSize))
        imageViewTL.image = UIImage(named: "scan_tl")
        //imageSize = (imageViewTL.image?.size.width)!
        self.view.addSubview(imageViewTL)
        
        let imageViewTR = UIImageView(frame: CGRectMake(imageX + width - imageSize, imageY, imageSize, imageSize))
        imageViewTR.image = UIImage(named: "scan_tr")
        self.view.addSubview(imageViewTR)
        
        let imageViewBL = UIImageView(frame: CGRectMake(imageX, imageY + height - imageSize, imageSize, imageSize))
        imageViewBL.image = UIImage(named: "scan_bl")
        self.view.addSubview(imageViewBL)
        
        let imageViewBR = UIImageView(frame: CGRectMake(imageX + width - imageSize, imageY + height - imageSize, imageSize, imageSize))
        imageViewBR.image = UIImage(named: "scan_br")
        self.view.addSubview(imageViewBR)
        
        line = UIImageView(frame: CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 2))
        line.image = UIImage(named: "scan_line")
        self.view.addSubview(line)
    }
    
    //MARKS: 设置扫描区域界面
    func makeScanCameraShadowView(innerRect: CGRect) -> UIView {
        let referenceImage = UIImageView(frame: self.view.bounds)
        
        UIGraphicsBeginImageContext(referenceImage.frame.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetRGBFillColor(context, 0, 0, 0, 0.5)
        var drawRect = CGRectMake(0, 0, screenWidth, screenHeight)
        CGContextFillRect(context, drawRect)
        drawRect = CGRectMake(innerRect.origin.x - referenceImage.frame.origin.x, innerRect.origin.y - referenceImage.frame.origin.y, innerRect.size.width, innerRect.size.height)
        
        CGContextClearRect(context, drawRect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        referenceImage.image = image
        
        return referenceImage
    }
    
    // MARK: Rect
    func makeScanReaderRect() -> CGRect {
        let scanSize = (min(screenWidth, screenHeight) * 3) / 4

        var scanRect = CGRectMake(0, 0, scanSize, scanSize)
        
        scanRect.origin.x += (screenWidth / 2) - (scanRect.size.width / 2)
        scanRect.origin.y += (screenHeight / 2) - (scanRect.size.height / 2)
        
        return scanRect
    }

    
    //MARKS: 设置AVCaptureMetadataOutput 的rectOfInterest 属性来配置解析范围
    //MARKS: iPhone4s屏幕,大小640x960
    func makeScanReaderInterestRect2(captureMetaOutput:AVCaptureMetadataOutput){
        let cropRect = makeScanReaderRect()
        
        let size:CGSize = self.view.bounds.size
        let bounds:CGRect = self.view.bounds
        let p1:CGFloat = size.height/size.width
        let p2:CGFloat = 1920/1080;  //使用了1080p的图像输出
        if (p1 < p2) {
            let fixHeight:CGFloat = bounds.size.width * 1920 / 1080
            let fixPadding:CGFloat = (fixHeight - size.height)/2
            captureMetaOutput.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                      cropRect.origin.x/size.width,
                                                      cropRect.size.height/fixHeight,
                                                      cropRect.size.width/size.width)
        } else {
            let fixWidth:CGFloat = bounds.size.height * 1080 / 1920
            let fixPadding:CGFloat = (fixWidth - size.width)/2
            captureMetaOutput.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                                      (cropRect.origin.x + fixPadding)/fixWidth,
                                                      cropRect.size.height/size.height,
                                                      cropRect.size.width/fixWidth)
        }
        
    }
    
    func makeScanReaderInterestRect() -> CGRect {
        let rect = makeScanReaderRect()
        let x = rect.origin.x / screenWidth
        let y = rect.origin.y / screenHeight
        let width = rect.size.width / screenWidth
        let height = rect.size.height / screenHeight
        
        return CGRectMake(x, y, width, height)
    }
    
    //MARKS: 是否打开权限
    func initSecutry() -> Bool{
        //获取相机权限
        let status:AVAuthorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        //判断摄像头是否打开
        /*if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            return false
        }*/
        
        if(status == .Restricted || status == .Denied){
            return false
        }
        
        return true
    }
    
    //MARKS: 初始化权限
    func initSetting() -> Bool{
        if !initSecutry() {
            let alertController = UIAlertController(title: "二维码扫描", message: "请在iPhone的“设置”-“隐私”-“相机”功能中，找到“WeChat”打开相机访问权限", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
            
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    // MARKS: 定时器
    func scanLineAnimation() {
        let rect = makeScanReaderRect()
        
        let lineFrameX = rect.origin.x
        let lineFrameY = rect.origin.y
        let downHeight = rect.size.height
        
        if upORdown == false {
            traceNumber += 1
            line.frame = CGRectMake(lineFrameX, lineFrameY + CGFloat(2 * traceNumber), downHeight, 2)
            if CGFloat(2 * traceNumber) > downHeight - 2 {
                upORdown = true
            }
        }
        else
        {
            traceNumber -= 1
            line.frame = CGRectMake(lineFrameX, lineFrameY + CGFloat(2 * traceNumber), downHeight, 2)
            if traceNumber == 0 {
                upORdown = false
            }
        }
    }
    
    //MARKS: 解码二维码
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            return
        }
        
        if metadataObjects.count == 0 {
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        let alertController = UIAlertController(title: "扫描结果", message: metadataObj.stringValue, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
