//
//  TWUser.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

/**
 A model of the user information.
 
 This `Class` is a model of the TWUser.
 
 - Author: Mike Silvers
 - Date: 3/25/19
 */

class TWUser : Codable {
    
    //MARK: Variable definitions
    var userName          : String = "TW User"
    var firstName         : String?
    var lastName          : String?
    
    var lastLoggedInTime  : Int = 0
    var lastLoggedOutTime : Int = 0

    //MARK: Supporting enum
    /**
     This `enum` defines the coding keys for the encoding/decoding of information to/from JSON.
     */
    enum CodingKeys: String, CodingKey {
        case userName          = "UserName"
        case firstName         = "FirstName"
        case lastName          = "LastName"
        case lastLoggedInTime  = "LastLoggedInTime"
        case lastLoggedOutTime = "LastLoggedOutTime"
    }
    
    //MARK: Initializers

    /**
     
     An `init` function containing all attributes.
     
     This `init` function provides an option to create a `Tweet` while providing all attriutes
     
     - Parameter username: The user username
     - Parameter firstname: The user first name
     - Parameter lastname: The user last name
     - Parameter lastloggedintime: The last time the user has successfullt logged in
     */

    init (username: String, firstname: String, lastname: String, lastloggedintime: Int) {
        // set the object parameters according to the initializer parameters
        userName = username
        firstName = firstname
        lastName = lastname
        lastLoggedInTime = lastloggedintime
    }
    
    /**
     The default initializer as required.
     
     Provides a default initializer with no parameters.  This allows us to create a base object.  No configuration is required as there are no default values for the user.
    */
    init() { }
    
}
