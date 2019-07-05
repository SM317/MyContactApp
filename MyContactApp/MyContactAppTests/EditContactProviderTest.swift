//
//  EditContactProviderTest.swift
//  MyContactAppTests
//
//  Created by SourabhMehta on 24/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import XCTest
@testable import MyContactApp
class EditContactProviderTest: XCTestCase {

      let contactId : Int = 6173
     let parameterDictionary : NSMutableDictionary = [Constants.ContactsKeys.firstName: "Sourabh",Constants.ContactsKeys.lastName: "Mehta",Constants.ContactsKeys.phoneNumber: "8949645905",Constants.ContactsKeys.email: "mehta.sourabh31@gmail.com",Constants.ContactsKeys.updatedAt:Constants.getCurrentTime()]
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testUpdateContact() {
        // Create an expectation object.
        let updateContact = expectation(description: "Contacts details updated successfully.")
      
        let dictMain : NSMutableDictionary = [:]
        parameterDictionary.setValue(contactId, forKey: Constants.ContactsKeys.contactId)
        dictMain.setValue(parameterDictionary, forKey: DATA)
        EditContactProvider.updateContact(withContactId: contactId, with: dictMain,withCompletion: { result in
            switch result {
            case .success(_):
                XCTAssert(true)
                updateContact.fulfill()
            case .failure(_):
                XCTFail("Could not update the contacts Details")
            }
        })
        waitForExpectations(timeout: 10, handler: { error in })
    }
    
    func testCreateContact() {
        // Create an expectation object.
        let createContact = expectation(description: "New contact must be created")
        let dictMain : NSMutableDictionary = [:]
        parameterDictionary.setValue(0, forKey: Constants.ContactsKeys.contactId)
        dictMain.setValue(parameterDictionary, forKey: DATA)
        
        EditContactProvider.createContact(withContactId: 0, with: dictMain,withCompletion: { result in
            switch result {
            case .success(_):
                XCTAssert(true)
                createContact.fulfill()
            case .failure(_):
                XCTFail("Could not updated the favorite status of the contact")
            }
        })
        waitForExpectations(timeout: 30, handler: { error in })
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
