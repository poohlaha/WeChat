//
//  Contact.swift
//  WeChat
//
//  Created by Smile on 16/1/8.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit
import Contacts

class Contact {
    
     //MARKS: Properties
    var photo:UIImage?
    var name:String
    var phone:String
    
    //MARKS: Init
    init?(name:String,photo:UIImage?,phone:String){
        self.name = name
        self.photo = photo
        self.phone = phone
        if name.isEmpty || phone.isEmpty {
            return nil
        }
    }
}

class ContactSession {
    var key:String
    var contacts:Array<Contact>
    
    init(){
        key = ""
        contacts = [Contact]()
    }
}

//MARKS: 获取联系人
class ContactModel {
    
    //MARKS: Properties
    let image = ["contact1","contact2","contact3"]
    var contacts = [CNContact]()
    var contactSesion = [ContactSession]()
    
    init(){
       searchContact()
    }
    
    func searchContact(){
        let contactStore = CNContactStore()
        let keyToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),CNContactImageDataKey,CNContactPhoneNumbersKey]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keyToFetch)
        
        do {
            try contactStore.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: { (contact, stop) -> Void in
                self.contacts.append(contact)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        setContacts()
    }
    
    func setContacts(){
        var phoneNumber = ""
        var name = ""
        var photoName = ""
        var count:Int = 0
        
        for contact in self.contacts {
            name = "\(contact.familyName)\(contact.givenName)"
            
            if count % 3 == 0 {
                photoName = image[0]
            } else if count % 3 == 1 {
                photoName = image[1]
            } else {
               photoName = image[2]
            }
            
            for number in contact.phoneNumbers {
                let phone = number.value as! CNPhoneNumber
                if phone.stringValue.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                    phoneNumber = phone.stringValue
                    break
                }
            }
            
            let friend = Contact(name:name,photo:UIImage(named: photoName),phone:phoneNumber)!
            saveContactsModel(friend)
        
            count++
        }
    }
    
    //save in session
    func saveContactsModel(contact:Contact){
        var new = true
        var englishName = getEnglistByName(contact.name) as String
        if englishName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 1 {
            englishName = "*"
        }
        
        let firstChar = englishName.substringToIndex(englishName.startIndex.advancedBy(1)).uppercaseString
        
        for session in contactSesion {
            if session.key == firstChar {
                new = false
                session.contacts.append(contact)
                break;
            }
        }
        
        if new {
            let newContactSession = ContactSession()
            newContactSession.key = firstChar.uppercaseString
            newContactSession.contacts = [contact]
            contactSesion.append(newContactSession)
        }
    }
    
    
    //MARKS: 获取中文的拼音
    private func getEnglistByName(name:String) -> String{
        let s =  NSMutableString(string:name) as CFMutableString
        CFStringTransform(s, nil, kCFStringTransformMandarinLatin, false)
        //去掉音标
        CFStringTransform(s, nil, kCFStringTransformStripDiacritics, false)
        print(s)
        return s as String
    }
}