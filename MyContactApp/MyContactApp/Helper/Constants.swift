//
//  Constants.swift
//  MyContactApp
//
//  Created by SourabhMehta on 21/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import Foundation
import UIKit

 struct Constants {
    
    enum Config {
        static let baseURL = "https://gojek-contacts-app.herokuapp.com/contacts"
        static let requestURL = ".json"
    }
    
    enum Color
    {
        static let primaryColor  = UIColor.init(hexString: "#50E3C2")
        static let primaryLighterColor = UIColor.init(hexString: "#DEF5EF")
        static let secondaryColor = UIColor.lightGray
        static let contactLabelColor =  UIColor.init(hexString: "#4A4A4A")
    }
    
    enum Length
    {
        static let phoneNumber: Int = 13
    }
    
    enum ControllerIdentifier
    {
        static let detailController = "ViewDetail"
        static let editController = "ViewEdit"
    }
    
    enum TableIdentifier
    {
        static let contactCell = "contactCell"
    }
    
    enum TableConstants
    {
        static let CELLHEIGHT : CGFloat = 64.0
    }
    
    enum TableCustomCell
    {
        static let contact  = "ContactListCustomCell"
    }
    
    enum Images
    {
        static let defaultPhotoImage  = "placeholder_photo"
        static let favoriteSelected      = "favourite_button"
        static let favoriteUnselected  = "favourite_button_selected"
        static let takePhoto                = "take_photo"
    }
    
    enum ContactsKeys{
        static let favorite = "favorite"
        static let contactId = "id"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let phoneNumber = "phone_number"
        static let email = "email"
        static let createdAt = "created_at"
        static let updatedAt = "updated_at"
    }
    
    /**
     getting the current time in iso8601 format
   */
    
    static func getCurrentTime() -> String
    {
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        let strDate = formatter.string(from: now as Date)
        return strDate
    }
    
    /**
     check whether the enter email is valid or not
     - parameter email:         email of the contact
     */
  static  func isValidEmail(_ email:String)-> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
    
}



