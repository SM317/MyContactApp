//
//  ContactTest.swift
//  MyContactAppTests
//
//  Created by SourabhMehta on 24/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import XCTest
@testable import MyContactApp

class ContactTest: XCTestCase {

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

    func testContactFullName() {
        // Create an expectation object.
        let contactFullname = expectation(description: "Contacts full name matches with the provided contact")
        let contact : Contact = Contact(id: 6281, firstName: "Sourabh", lastName: "Mehta", profilePic: "", favorite: true, url: "", phoneNumber: "", email: "", createdAt: "", updatedAt: "")
        XCTAssertEqual(contact.fullName, "Sourabh Mehta")
        contactFullname.fulfill()
        waitForExpectations(timeout: 10, handler: { error in })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
