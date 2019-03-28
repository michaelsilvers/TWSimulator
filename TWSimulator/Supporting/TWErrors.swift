//
//  TWErrors.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

/**
 Custom errors describing user related information.
 
 This error `enum` defines the user related errors.  Additional errors are added when additional user functionality is added to the project.
 
 - Author: Mike Silvers
 - Date: 3/25/19
 */
//MARK: User Errors
enum UserError: Error {
    
    /**
        When creating a new username, this error indicates that the username already exists
     */
    case UsernameExists
    
    /**
        When creating a password, this error indicates that the password strength does not meet standards
     */
    case PasswordNotStrong
    
    /**
        When loggin in, this error indicates an incorrect condition, either username or password is incorrect.
     
        For security reasons, we do not tell them which is incorrect - just that the combination is incorrect
     */
    case UsernameOrPasswordIncorrect
        
}
