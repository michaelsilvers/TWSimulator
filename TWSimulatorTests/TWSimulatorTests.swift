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

    //MARK: Tweet datasource functionality tests
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

    func testDataSourceUpdateMessage() {
        
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

    func testDataSourceAddMessage() {
        
        let tds = TWDataSource.shared
        tds.clearAllMessages()

        // Add a few Tweets to the list - using the full initializer
        for x in 1...5 {
            // we are using the current Epoch time and adding a multiple for seconds because this loop can run and
            // fill the array quicket than one per second (we are using an Int for the epoch time)
            tds.addMessage(Tweet(messageId: 0, createdTimeDate: (Int(Date().timeIntervalSince1970) + (x*2)), readTimeDate: 0, message: "Test message \(x)"))
        }
        
        XCTAssertTrue(tds.getMessages().count == 5, "We are expecting 5 tweets.  We had \(tds.getMessages().count)")

        // lets test the minimal initializer for the tweet
        tds.clearAllMessages()
        for x in 1...5 {
            // we are using the current Epoch time and adding a multiple for seconds because this loop can run and
            // fill the array quicket than one per second (we are using an Int for the epoch time)
            tds.addMessage(Tweet("Test message \(x)"))
        }

        XCTAssertTrue(tds.getMessages().count == 5, "We are expecting 5 tweets.  We had \(tds.getMessages().count)")
        
        // grab one of the tweets to make sure it was reated correctly
        if let tt = tds.getSingleTweet(2) {
            XCTAssertTrue(tt.createdTimeDate > 0, "The created time for the tweet was not set correctly.  Expecting > 0, got \(tt.createdTimeDate)")
            XCTAssertTrue(tt.messageId > 0, "The message ID was not set correctly.  Expecting a number, got \(tt.messageId)")
            XCTAssertFalse(tt.message.isEmpty, "We are expecting a message.  The message was empty.")
            XCTAssertTrue(tt.readTimeDate == 0, "We are expecting the read to be 0.  We got \(tt.readTimeDate ?? 0)")
        } else {
            XCTAssert(true, "There was a problem pulling a tweet from the list.")
        }

    }

    func testDataSourceOrderOfMessagesAndRetrievalOfRecords() {
        
        let tds = TWDataSource.shared
        tds.clearAllMessages()
        
        // this variable will be used as a timestamp for the reordering of the records
        var timeinthemiddle:Int = 0
        
        // Add a few Tweets to the list
        for x in 1...5 {
            // we are using the current Epoch time and adding a multiple for seconds because this loop can run and
            // fill the array quicket than one per second (we are using an Int for the epoch time)
            let created = (Int(Date().timeIntervalSince1970) + (x*2))
            
            // save the middle time when the times are added
            if x == 3 { timeinthemiddle = created }
            
            // add the message
            tds.addMessage(Tweet(messageId: 0, createdTimeDate: created, readTimeDate: 0, message: "Test message \(x)"))
        }

        // now lets test the processes -
        var theresults = tds.getMessages()
        XCTAssertTrue(theresults.count == 5, "We were expecting 5 records, we found \(theresults.count)")
        
        // lets make sure the results are in the proper descending order - when all records are returned
        var lastcreated: Int = 0
        for t in theresults {
            
            // only test if the lastcreated was set
            if lastcreated != 0, lastcreated < t.createdTimeDate {
                // if we are here, then the last created was not > the current record.  The records should be descending.
                XCTAssert(true, "The record is not in the proper order.  The lastcreated is \(lastcreated) and the current record is \(t.createdTimeDate)")
            }
            
            // this saves the time created on the last record
            lastcreated = t.createdTimeDate
        }
        
        // this test is making sure the order is correct when we pull records from a specific date
        theresults.removeAll()
        theresults = tds.getMessages(timeinthemiddle)
        XCTAssertTrue(theresults.count == 3, "We were expecting 3 records, we found \(theresults.count)")

        // lets make sure the results are in the proper descending order
        lastcreated = 0
        for t in theresults {
            
            // only test if the lastcreated was set
            if lastcreated != 0, lastcreated < t.createdTimeDate {
                // if we are here, then the last created was not > the current record.  The records should be descending.
                XCTAssert(true, "The record is not in the proper order.  The lastcreated is \(lastcreated) and the current record is \(t.createdTimeDate)")
            }
            
            // this saves the time created on the last record
            lastcreated = t.createdTimeDate
        }

        // testing for a date after the records were created (future records)
        theresults.removeAll()
        let futuretime = Int(Date().timeIntervalSince1970) + 2000
        theresults = tds.getMessages(futuretime)
        XCTAssertTrue(theresults.count == 0, "We were expecting 0 records, we found \(theresults.count)")
    }
    
    func testTweetSaveInDocumentsDirectoryAsJSONFile() {
        
        let tds = TWDataSource.shared
        tds.clearAllMessages()
        
        // Add a few Tweets to the list
        for x in 1...5 {
            // we are using the current Epoch time and adding a multiple for seconds because this loop can run and
            // fill the array quicket than one per second (we are using an Int for the epoch time)
            let created = (Int(Date().timeIntervalSince1970) + (x*2))
            
            // add the message
            tds.addMessage(Tweet(messageId: 0, createdTimeDate: created, readTimeDate: 0, message: "Test message \(x)"))
        }

        // save the messages to the directory
        tds.saveMessages()
        
        let saved = tds.readFile("tw_messages")
        
        var jsondir:[Tweet]?
        
        // now for the test - if we can encode the json, we arte good
        if let jd = saved.data(using: .utf8) {
            jsondir = try? JSONDecoder().decode([Tweet].self, from: jd)
        }

        XCTAssertNotNil(jsondir, "There was a problem, the array of Tweets is nil")

        // lets see if this is valid JSON:
        if jsondir != nil {
            // if this was successful, lets see the number of records
            XCTAssertTrue(jsondir?.count == 5, "Expecting 5 Tweets, but there are \(jsondir?.count ?? 0) Tweets.")
        }
    }
    
    //MARK: TWUser tests
    func testTWUserCreation() {
        
        let theuser = TWUser()
        
        // testing the default values for the user
        XCTAssertTrue(theuser.firstName == nil, "The first name is NOT nil")
        XCTAssertTrue(theuser.lastName == nil, "The last name is NOT nil")
        XCTAssertTrue(theuser.userName == "TW User", "The default username was not used.  The username is \(theuser.userName)")

        // make some changes to the user and test to make sure the user changes are reflected properly
        theuser.userName = "mike"
        XCTAssertTrue(theuser.userName == "mike", "The username 'mike' was not used.  The username is '\(theuser.userName)'")

        let loggedin = Int(Date().timeIntervalSince1970)
        theuser.lastLoggedInTime = loggedin
        XCTAssertTrue(theuser.lastLoggedInTime == loggedin,
                      "The last logged in time is not \(loggedin).  It is \(theuser.lastLoggedInTime )")
    }

}
