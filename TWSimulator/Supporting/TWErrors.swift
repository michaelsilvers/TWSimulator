//
//  TWErrors.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

struct UserError: Error {
    
    enum UserErrorTypes {
        case UsernameExists
        case PasswordNotStrong
        case UsernameOrPasswordIncorrect
    }
    
    let message : String
    let errorType : UserErrorTypes
    
}
