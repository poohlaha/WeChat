//
//  AddressPickerViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/23.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

@objc protocol AddressPickerViewDelegate {
    optional func cancelClick()
    optional func doneClick()
}

//PickerView 三级联动选择城市
class AddressPickerView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {

    var addressPickerView:UIPickerView!
    var dataDic:NSDictionary!//数据
    var provinceArray:NSArray!//省
    var cityArray:NSArray!//市
    var townArray:NSArray!//区
    var selectedArray:NSArray!//选中的值
    var topView:UIView!
    let topViewHeight:CGFloat = 50
    var pickViewDelegate:AddressPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        initView()
    }
    
    func initView(){
        initPickerData()
        initTopView()
        initPicker()
    }
    
    func initPicker(){
        addressPickerView = UIPickerView(frame: CGRectMake(0,topViewHeight,self.frame.width,self.frame.height))
        self.addressPickerView.dataSource = self
        self.addressPickerView.delegate = self
        self.addSubview(addressPickerView)
    }
    
    func initTopView(){
        self.topView = UIView()
        self.topView.frame = CGRectMake(0, 0, self.frame.width, topViewHeight)
        self.topView.backgroundColor = UIColor.darkGrayColor()
        
        let leftOrRightPadding:CGFloat = 10
        let btnHeight:CGFloat = 35
        let btnWidth:CGFloat = 50
        let topPadding:CGFloat = (topViewHeight - btnHeight) / 2
        
        let cancelBtn = UIButton(type: .Custom)
        cancelBtn.frame = CGRectMake(leftOrRightPadding, topPadding, btnWidth, btnHeight)
        cancelBtn.setTitle("取消", forState: .Normal)
        cancelBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancelBtn.layer.borderWidth = 0
        cancelBtn.addTarget(self, action: #selector(AddressPickerView.cancelClick), forControlEvents: .TouchUpInside)
        self.topView.addSubview(cancelBtn)
        
        let doneBtnBeginX:CGFloat = self.frame.width - leftOrRightPadding - btnWidth
        let doneBtn = UIButton(type:.Custom)
        doneBtn.frame = CGRectMake(doneBtnBeginX, topPadding, btnWidth, btnHeight)
        doneBtn.setTitle("完成", forState: .Normal)
        doneBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        doneBtn.layer.borderWidth = 0.2
        doneBtn.layer.cornerRadius = 5
        doneBtn.backgroundColor = UIColor(red: 0/255, green: 170/255, blue: 221/255, alpha:1)
        doneBtn.addTarget(self, action: #selector(AddressPickerView.doneClick), forControlEvents: .TouchUpInside)
        self.topView.addSubview(doneBtn)
        
        self.addSubview(topView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARKS: 取消事件
    func cancelClick(){
        pickViewDelegate?.cancelClick!()
    }
    
    //MARKS: 完成事件
    func doneClick(){
        pickViewDelegate?.doneClick!()
    }
    
    //MARKS: 初始化数据
    func initPickerData(){
        let path = NSBundle.mainBundle().pathForResource("area", ofType: "plist")
        self.dataDic = NSDictionary.init(contentsOfFile: path!)
        self.provinceArray = self.dataDic.allKeys
        self.selectedArray = self.dataDic.objectForKey(self.dataDic.allKeys[0]) as! NSArray
        if self.selectedArray.count > 0 {
            self.cityArray = self.selectedArray[0].allKeys
        }
        
        if self.cityArray.count > 0 {
            self.townArray = self.selectedArray[0].objectForKey(self.cityArray[0]) as! NSArray
        }
    }
    
    //MARKS: 该方法的返回值决定该控件包含多少列
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    //MARKS: 该方法的返回值决定该控件指定列包含多少个列表项
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.provinceArray.count
        } else if component == 1 {
            return self.cityArray.count
        } else {
            return self.townArray.count
        }
    }
    
    //MARKS: 该方法返回的String将作为UIPickerView中指定列和列表项的标题文本
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.provinceArray[row] as? String
        } else if component == 1 {
            return self.cityArray[row] as? String
        } else {
            return self.townArray[row] as? String
        }
    }
    
    //MARKS: 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.selectedArray = self.dataDic.objectForKey(self.provinceArray[row]) as! NSArray
            if self.selectedArray.count > 0 {
                self.cityArray = self.selectedArray[0].allKeys
            } else {
                self.cityArray = nil
            }
            
            if self.cityArray.count > 0 {
                self.townArray = self.selectedArray[0].objectForKey(self.cityArray[0]) as! NSArray
            } else {
                self.townArray = nil
            }
            
            pickerView.selectedRowInComponent(1)
            pickerView.reloadComponent(1)
            pickerView.selectedRowInComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: false)
            pickerView.selectRow(0, inComponent: 2, animated: false)
        }
        

        if component == 1 {
            if self.selectedArray.count > 0 && self.cityArray.count > 0 {
                self.townArray = self.selectedArray[0].objectForKey(self.cityArray[row]) as! NSArray
            } else {
                self.townArray = nil
            }
            
            pickerView.selectRow(0, inComponent: 2, animated: false)
        }
        
        pickerView.reloadComponent(2)
        
    }
    
    func getSelectedData() -> String{
        let province = self.addressPickerView.selectedRowInComponent(0)
        let city = self.addressPickerView.selectedRowInComponent(1)
        let town = self.addressPickerView.selectedRowInComponent(2)
        return (self.provinceArray[province] as! String) + " " + (self.cityArray[city] as! String) + " " + (self.townArray[town] as! String)
    }
}
