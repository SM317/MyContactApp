//
//  ContactDetailViewControllerTest.swift
//  MyContactAppTests
//
//  Created by SourabhMehta on 24/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import XCTest
@testable import MyContactApp

class ContactDetailViewControllerTest: XCTestCase {

    var detail : ContactDetailViewController?
    var detailUrl : String = "https://gojek-contacts-app.herokuapp.com/contacts/6173.json"
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        detail = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ContactDetailViewController
        detail?.contactURL = detailUrl
    }

    override func tearDown() {
        detail = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
