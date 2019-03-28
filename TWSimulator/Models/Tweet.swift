//
//  Tweet.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

/**
 A model of a message.
 
 This `struct` is a model of the `Tweet` data.  The model implements the `Codable` protocol to allow for easy transformation to and from JSON.
 
 The model implements the `Comparable` protocol allowing for an easy method to determine if two `Tweet` items are the same.  The comparison is based on the unique `ID` for each `Tweet`.
 
 - Author: Mike Silvers
 - Date: 3/25/19
 */
struct Tweet : Codable, Comparable {
    
    //MARK: Variable definitions
    var messageId       : Int = 0
    var createdTimeDate : Int = 0
    var readTimeDate    : Int?
    
    var message         : String
    
    //MARK: Supporting enumerations
    /**
     This `enum` defines the coding keys for the encoding/decoding of information to/from JSON.
    */
    enum CodingKeys: String, CodingKey {
        
        case messageId       = "message_id"
        case createdTimeDate = "created_time"
        case readTimeDate    = "read_time"

        case message
    }

    //MARK: Comparable protocol functions
    /**
     
     This `static` function compares two objects to determine if they are not equal.
     
     The attribute determining equality is the `ID` for the item.
     
     - Parameter lhs: the initial item for comparison (this item)
     - Parameter rhs: the item to compare this item to
     - Returns: a `Bool` that indicates of the comparison is **true** or **false**
    */
    static func < (lhs: Tweet, rhs: Tweet) -> Bool {
        
        // we start by assuming that the two items are equal
        var compared = true
        
        // we only check the message ID as the other information may be different
        if lhs.messageId != rhs.messageId, compared { compared = false }
        
        // Quick note: We sould just return the `true` or `false` if conditions are met, but the current configuration allows for multiple test to be performed easily by using a `compared` variable.
        return compared
    }
    
    //MARK: Support functions
    /**
     
     This `private` function assigns the unique `ID` for this message.
     
     The attribute `ID` is set for the item.
     
     */
    private mutating func setID() {
        
        // set the ID if the ID is 0
        if messageId == 0 {
            messageId = TWDataSource.shared.nextIdNumber()
        }
    }
    
    //MARK: Initialization functions
    /**
     
     An `init` function containing the message only.
     
     This `init` function provides an option to create a `Tweet` while providing only the new message
     
     - Parameter newMessage: The message to be saved for this `Tweet`
     
     */
    init(_ newMessage: String) {
        
        // configure the required parameters
        messageId = TWDataSource.shared.nextIdNumber()
        createdTimeDate = Int(Date().timeIntervalSince1970)
        readTimeDate = 0
        
        // add the message to the `Tweet`
        message = newMessage
        
    }
    
    /**
     
     An `init` function containing all attributes.
     
     This `init` function provides an option to create a `Tweet` while providing all attriutes
     
     - Parameter messageId: The unique ID to be saved for this `Tweet`
     - Parameter createdTimeDate: The time and date created (in Epoch format) to be saved for this `Tweet`
     - Parameter readTimeDate: The time and date the `Tweet` was read (in Epoch format) to be saved for this `Tweet`
     - Parameter message: The message to be saved for this `Tweet`

     */
    init (messageId: Int, createdTimeDate: Int, readTimeDate: Int, message: String) {
        self.messageId = messageId
        self.createdTimeDate = createdTimeDate
        self.readTimeDate = readTimeDate
        self.message = message
    }
    
}
