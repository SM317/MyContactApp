//
//  Contact.swift
//  MyContactApp
//
//  Created by SourabhMehta on 21/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import Foundation

struct Contact: Decodable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let profilePic: String?
    let favorite: Bool?
    let url: String?
    let phoneNumber: String?
    let email: String?
    let createdAt : String?
    let updatedAt : String?
    
    var fullName: String {
        if firstName == nil && lastName == nil {
            return ""
        } else if firstName == nil {
            return lastName ?? ""
        } else if lastName == nil {
            return firstName ?? ""
        } else {
            return (firstName ?? "")  + " " + (lastName ?? "")
        }
    }
}

struct ContactListSection {
    let sectionTitle: String
    let contacts: [Contact]
}

