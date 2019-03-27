//
//  TWUser.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

// Note for reviewers: I am using NSObject and NSCoding here because we are saving the
// TWUser object in the keychain for security.  Saving an object in the keychain requires
// the NSObject and NSCoding protocols.
class TWUser : NSObject, NSCoding {
    
    var userName          : String = "TW User"
    var firstName         : String?
    var lastName          : String?
    
    var lastLoggedInTime  : Int = 0
    var lastLoggedOutTime : Int = 0

    enum Keys: String {
        case userName          = "UserName"
        case firstName         = "FirstName"
        case lastName          = "LastName"
        case lastLoggedInTime  = "LastLoggedInTime"
        case lastLoggedOutTime = "LastLoggedOutTime"
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(userName, forKey: Keys.userName.rawValue)
        aCoder.encode(firstName, forKey: Keys.firstName.rawValue)
        aCoder.encode(lastName, forKey: Keys.lastName.rawValue)
        aCoder.encode(lastLoggedInTime, forKey: Keys.lastLoggedInTime.rawValue)
        aCoder.encode(lastLoggedOutTime, forKey: Keys.lastLoggedOutTime.rawValue)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
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

    init (username: String, firstname: String, lastname: String, lastloggedintime: Int) {
        userName = username
        firstName = firstname
        lastName = lastname
        lastLoggedInTime = lastloggedintime
    }
    
    override init() { super.init() }
    
}
