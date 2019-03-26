//
//  TWSimulatorTests.swift
//  TWSimulatorTests
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import XCTest
@testable import TWSimulator

class TWSimulatorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataSourceNextIdNumber() {

        let tds = TWDataSource.shared
        tds.clearAllMessages()
        
        // first test when the tweet array is empty
        var nn = tds.nextIdNumber()
        XCTAssertTrue(nn == 1, "The next number for the ID should be 1, but the result was \(nn)")
        
        // Add a few Tweets to the list
        for x in 1...5 {
            // we are using the current Epoch time and adding a multiple for seconds because this loop can run and
            // fill the array quicket than one per second (we are using an Int for the epoch time)
            tds.addMessage(Tweet(messageId: 0, createdTimeDate: (Int(Date().timeIntervalSince1970) + (x*2)), readTimeDate: 0, message: "Test message \(x)"))
        }
        
        nn = tds.nextIdNumber()
        XCTAssertTrue(nn == 6, "The next number for the ID should be 6, but the result was \(nn)")

    }

    func testDataSourceAddMessage() {
        
        let tds = TWDataSource.shared
        tds.clearAllMessages()

        // Add a few Tweets to the list
        for x in 1...5 {
            // we are using the current Epoch time and adding a multiple for seconds because this loop can run and
            // fill the array quicket than one per second (we are using an Int for the epoch time)
            tds.addMessage(Tweet(messageId: 0, createdTimeDate: (Int(Date().timeIntervalSince1970) + (x*2)), readTimeDate: 0, message: "Test message \(x)"))
        }
        
        // lets pull the record in the middle - we will try and update it
        if let msg = tds.getSingleTweet(3) {
            // make sure the correct message was retrieved
            XCTAssertTrue(msg.messageId == 3, "Expecting a message ID of 3, got \(msg.messageId)")
            
            // lets save a copy - then make changes, save it and see if all is good
            var tmp_msg = msg
            
            let new_msg = "We changed the message to a new text"
            tmp_msg.message = new_msg
            tds.addMessage(tmp_msg)
            
            // now lets pull the message again and see if it was changed
            if let msg_t = tds.getSingleTweet(3) {
                
                // now lets see if the correct changes were made to the updated Tweets
                XCTAssertTrue(msg_t.message == new_msg, "The message was not updated correctly.  We found '\(msg_t.message)' and was expecting '\(new_msg)'.")
                
                // now lets make sure the rest of the information is the same
                XCTAssertTrue(msg_t.createdTimeDate == msg.createdTimeDate, "The created time was incorrect on the updated Tweet.  Found \(msg_t.createdTimeDate), expecting \(msg.createdTimeDate)")
                
            } else {
                // there was a problem updating the Tweet
                XCTAssert(true, "There was a problem updating the Tweet")
            }
        }

        
    }

    func testDataSourceUpdateMessage() {
        
    }

    func testDataSourceOrderOfMessages() {
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
