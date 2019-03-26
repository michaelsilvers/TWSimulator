//
//  Tweet.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

struct Tweet : Codable, Comparable {
    
    static func < (lhs: Tweet, rhs: Tweet) -> Bool {
        
        var compared = true
        
        // we only check the message ID as the other information may be different
        if lhs.messageId != rhs.messageId, compared { compared = false }

        return compared
    }
    
    var messageId       : Int = 0
    var createdTimeDate : Int = 0
    var readTimeDate    : Int?
    
    var message         : String
    
    enum CodingKeys: String, CodingKey {
        
        case messageId       = "message_id"
        case createdTimeDate = "created_time"
        case readTimeDate    = "read_time"

        case message
    }
    
    private mutating func setID() {
        
        // set the ID if the ID is 0
        if messageId == 0 {
            messageId = TWDataSource.shared.nextIdNumber()
        }
    }
    
}
