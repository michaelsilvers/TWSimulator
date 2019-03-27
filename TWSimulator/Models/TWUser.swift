//
//  TWUser.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

class TWUser {
    
    var userName          : String = "TW User"
    var firstName         : String?
    var lastName          : String?
    
    var lastLoggedInTime  : Int?
    var lastLoggedOutTime : Int?

    init (username: String, firstname: String, lastname: String, lastloggedintime: Int) {
        userName = username
        firstName = firstname
        lastName = lastname
        lastLoggedInTime = lastloggedintime
    }
    
    init() { }
    
}
