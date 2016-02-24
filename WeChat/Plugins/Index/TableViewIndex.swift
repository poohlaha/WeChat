
//
//  TableViewIndex.swift
//  WeChat
//
//  Created by Smile on 16/1/10.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义索引
class TableViewIndex:UIView {

    var shapeLayer:CAShapeLayer?
    var fontSize:CGFloat?
    var letterHeight:CGFloat?
    var isLayedOut:Bool = false
    var letters = [String]()
    
    var tableView: UITableView?
    var datas = [ContactSession]()
    
    init(frame: CGRect,tableView:UITableView,datas:[ContactSession]) {
        self.letterHeight = 14;
        fontSize = 12;
        //letters = UILocalizedIndexedCollation.currentCollation().sectionTitles
        
        self.tableView = tableView
        self.datas = datas
        
        //MARKS: Get All Keys
        if datas.count > 0 {
            for(var i = 0;i < datas.count;i++){
                let key = datas[i].key
                if !key.isEmpty {
                    letters.append(key)
                }
            }
        }
        
        let height:CGFloat = self.letterHeight! * CGFloat(datas.count)
        //重新计算位置
        let beginY:CGFloat = (tableView.bounds.height - height) / 2
        super.init(frame: CGRectMake(frame.origin.x, beginY, frame.width, height))

        //super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setUp(){
        shapeLayer = CAShapeLayer()
        shapeLayer!.lineWidth = 0.5// 线条宽度
        shapeLayer!.fillColor = UIColor.clearColor().CGColor// 闭环填充的颜色
        shapeLayer!.lineJoin = kCALineCapSquare
        shapeLayer!.strokeColor = UIColor.clearColor().CGColor// 边缘线的颜色
        shapeLayer!.strokeEnd = 1.0
        self.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setUp()
        
        if !isLayedOut {
            shapeLayer?.frame.origin = CGPointZero
            shapeLayer?.frame.size = self.layer.frame.size

            var count:CGFloat = 0
            for i in self.letters{
                if !letters.contains(i){
                    continue
                }
                
                let originY = count * self.letterHeight!
                let text = textLayerWithSize(fontSize!, string: i, frame: CGRectMake(0, originY, self.frame.size.width, self.letterHeight!))
                self.layer.addSublayer(text)
                
                count++
            }
            
            self.layer.addSublayer(shapeLayer!)
            
            isLayedOut = true
        }
    }
    
    func reloadLayout(edgeInsets:UIEdgeInsets){
        /*var rect = self.frame;
        rect.size.height = self.indexs.count * self.letterHeight;
        rect.origin.y = edgeInsets.top + (self.superview!.bounds.size.height - edgeInsets.top - edgeInsets.bottom - rect.size.height) / 2;
        self.frame = rect;*/
    }
    
    func textLayerWithSize(size:CGFloat,string:String,frame:CGRect) -> CATextLayer{
        let textLayer = CATextLayer()
        textLayer.font = CTFontCreateWithName("TrebuchetMS-Bold",size,nil)
        textLayer.fontSize = size
        textLayer.frame = frame
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.mainScreen().scale
        //textLayer.foregroundColor  = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).CGColor
        
        textLayer.foregroundColor = UIColor.grayColor().CGColor
        textLayer.string = string
        return textLayer
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        sendEventToDelegate(event!)
    }
    
    func sendEventToDelegate(event:UIEvent){
        let point = (event.allTouches()! as NSSet).anyObject()?.locationInView(self)
        let index = Int(floorf(Float(point!.y)) / Float(self.letterHeight!))
        if (index < 0 || index > self.letters.count - 1) {
            return;
        }
        
        didSelectSectionAtIndex(index, withTitle: self.letters[index])
    }
    
    func didSelectSectionAtIndex(index:Int,withTitle title:String){
        if (index > -1){
            for(var i = 0; i < tableView!.numberOfSections;i++) {
                let key = datas[i].key
                if key == title {
                    tableView!.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: i), atScrollPosition: .Top, animated: false)
                }
            }
            
        }
    }
}
