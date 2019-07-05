//
//  ContactDetailProviderTest.swift
//  MyContactAppTests
//
//  Created by SourabhMehta on 24/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import XCTest
@testable import MyContactApp
class ContactDetailProviderTest: XCTestCase {

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

    func testContactsDetails() {
        // Create an expectation object.
        let contactsDetailsRetrieved = expectation(description: "Contacts details retrieved")
        let contactUrl = "https://gojek-contacts-app.herokuapp.com/contacts/6173.json"
        ContactDetailProvider.contactsDetails(withContactString: contactUrl,withCompletion: { result in
            switch result {
            case .success(_):
                XCTAssert(true)
                contactsDetailsRetrieved.fulfill()
            case .failure(_):
                XCTFail("Could not retrieve contacts Details")
            }
        })
        waitForExpectations(timeout: 30, handler: { error in })
    }
    
    func testSetFavoriteStatus() {
        // Create an expectation object.
        let setFavoriteStatus = expectation(description: "Contact favorite status must be updated")
        let contactId = 6173
        let parameterDictionary : NSDictionary = [Constants.ContactsKeys.favorite: true,Constants.ContactsKeys.contactId: contactId]
        let dictMain : NSMutableDictionary = [:]
        dictMain.setValue(parameterDictionary, forKey: DATA)
        ContactDetailProvider.setFavoriteStatus(withContactId: contactId, with: dictMain,withCompletion: { result in
            switch result {
            case .success(_):
                XCTAssert(true)
                setFavoriteStatus.fulfill()
            case .failure(_):
                XCTFail("Could not updated the favorite status of the contact")
            }
        })
        waitForExpectations(timeout: 10, handler: { error in })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
