//
//  TWComms.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/26/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

/**
 Controls the communications for checking the user login information.
 
 This `struct` controls the communications between the local app and the servrs, if present.
 
 - Note: The initial implementation only checks the login for a single local user.  In the future, this is where the RESTful API calls will be completed.
 
 - Author: Mike Silvers
 - Date: 3/26/19
 */
struct TWComms {
    
    //MARK: Variable definitions
    private let secretUsername = "mike"
    private let secretPassword = "mike"
    
    //MARK: Login functions
    /**
     This function process the login request for a specific user.
     
     This function checks if the user provided information is correct.
     
     If the login information is not correct, the return is `nil` and the appropriate error is thrown.
     
     If the correct user information is provided, the `TWUser` object is saved to the keychain.  Saving the object to the keychain provides a secure and easy method to pull current user information.
     
     - Parameter username: The username to login.
     - Parameter password: The password to check with the username for login.
     
     - Throws: `UserError.UsernameOrPasswordIncorrect` The error is thrown if the username does not exist or the username does not authenticate with the password supplied
     
     - Returns: `TWUser` *or* `nil`.
     
     */
    func checkLogin(_ username: String, _ password: String) throws -> TWUser?  {
        
        // lets check the username and password (normally an API call - here it is just static variables)
        // we are taking the complete string - if you pass a space at the end of the username, that is part of the username for the authentication processes
        if username != secretUsername || password != secretPassword {
            // there was a problem with authentication - throw the error
            throw UserError.UsernameOrPasswordIncorrect
        }
        
        // we will add the user to the keychain - this will allow us to retrieve it from the secure location later - and remember - this information is static for this sample app
        let user = TWUser(username: "mike", firstname: "Mike", lastname: "Silvers", lastloggedintime: Int(Date().timeIntervalSince1970))
        
        // return the user object to the caller for them to reference as the app is running
        return user
    }
}
