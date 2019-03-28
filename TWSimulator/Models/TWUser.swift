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
 
 This `struct` is a model of the TWUser`.  The model extends the `NSObject` base object to allow the object to be saved inthe keychain.
 
 The model implements the `NSCoding` protocol allowing for an easy method to determine if two users are the same.  The user comparison is based on the unique `ID` for each user.

 - Note: We use NSObject and NSCoding here because we are saving the `TWUser` object in the keychain for security.  Saving an object in the keychain requires the NSObject and NSCoding protocols.

 - Author: Mike Silvers
 - Date: 3/25/19
 */

class TWUser : NSObject, NSCoding {
    
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
    enum Keys: String {
        case userName          = "UserName"
        case firstName         = "FirstName"
        case lastName          = "LastName"
        case lastLoggedInTime  = "LastLoggedInTime"
        case lastLoggedOutTime = "LastLoggedOutTime"
    }
    
    //MARK: NSCodable Protocol
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(userName, forKey: Keys.userName.rawValue)
        aCoder.encode(firstName, forKey: Keys.firstName.rawValue)
        aCoder.encode(lastName, forKey: Keys.lastName.rawValue)
        aCoder.encode(lastLoggedInTime, forKey: Keys.lastLoggedInTime.rawValue)
        aCoder.encode(lastLoggedOutTime, forKey: Keys.lastLoggedOutTime.rawValue)
        
    }

    //MARK: Initializers
    /**
     The default required initializer to confrm to the decoding protocol.
     
     This initializer processes the decoding to create an object when the decoder is passed as a parameter.
     
     - Parameter aDecoder: `NSCoder` object to be processed
    */
    required init?(coder aDecoder: NSCoder) {
        
        // process the attributes if they exist in the `NSCoder` object.
        if let data = aDecoder.decodeObject(forKey: Keys.userName.rawValue) as? String {
            userName = data
        }
        
        if let data = aDecoder.decodeObject(forKey: Keys.firstName.rawValue) as? String {
            firstName = data
        }
        
        if let data = aDecoder.decodeObject(forKey: Keys.lastName.rawValue) as? String {
            lastName = data
        }

        lastLoggedInTime = Int(aDecoder.decodeInt64(forKey: Keys.lastLoggedInTime.rawValue))
        lastLoggedOutTime = Int(aDecoder.decodeInt64(forKey: Keys.lastLoggedOutTime.rawValue))

    }

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
    override init() { super.init() }
    
}
