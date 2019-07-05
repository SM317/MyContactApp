//
//  ContactProvidertest.swift
//  MyContactAppTests
//
//  Created by SourabhMehta on 24/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import XCTest
@testable import MyContactApp

class ContactProvidertest: XCTestCase {

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

    func testContacts() {
        // Create an expectation object.
        let contactsRetrieved = expectation(description: "Contacts retrieved")
        ContactProvider.contacts(withCompletion: { result in
            switch result {
            case .success(let allContact):
                XCTAssert(allContact.count > 0)
                contactsRetrieved.fulfill()
            case .failure(_):
                 XCTFail("Could not retrieve contacts")
            }
        })
        waitForExpectations(timeout: 10, handler: { error in })
    }
    
    func testAllContactsWithIndex() {
        // Create an expectation object.
        let contactsWithIndexTitleRetrieved = expectation(description: "All Contacts retrieved with index title like A,B,C,....#")
        var contactListSections: [ContactListSection] = []
        ContactProvider.contacts(withCompletion: { result in
            switch result {
            case .success(let allContact):
                contactListSections = ContactProvider.getAllContactsWithIndex(contacts: allContact)
                XCTAssert(contactListSections.count > 0)
                contactsWithIndexTitleRetrieved.fulfill()
            case .failure(_):
                XCTFail("Could not retrieve contacts with index title like A,B,C,....#")
            }
        })
        waitForExpectations(timeout: 10, handler: { error in })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            ContactProvider.contacts(withCompletion: { result in
                switch result {
                case .success(let allContact):
                    XCTAssert(allContact.count > 0)
                case .failure(_):
                    XCTFail("Could not retrieve contacts")
                }
            })
        }
    }

}
