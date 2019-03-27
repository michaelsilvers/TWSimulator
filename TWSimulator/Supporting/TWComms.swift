//
//  TWComms.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/26/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

struct TWComms {
    
    private let secretUsername = "mike"
    private let secretPassword = "mike"
    
    func checkLogin(_ username: String, _ password: String) throws -> TWUser?  {
        
        // lets check the username and password (normally an API call - here it is just static variables)
        if username != secretUsername || password != secretPassword {
            throw UserError.UsernameOrPasswordIncorrect
        }
        
        return TWUser(username: "mike", firstname: "Mike", lastname: "Silvers", lastloggedintime: Int(Date().timeIntervalSince1970))
    }
}
