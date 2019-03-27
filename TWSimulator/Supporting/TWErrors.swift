//
//  TWErrors.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

enum UserError: Error {
    
    case UsernameExists
    case PasswordNotStrong
    case UsernameOrPasswordIncorrect
        
}

enum FieldErrors: Error {
    
    case emptyFieldError(_ message: String)
    
}
