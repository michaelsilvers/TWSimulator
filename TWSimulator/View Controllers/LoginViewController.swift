//
//  LoginViewController.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    // MARK: Variable declarations
    @IBOutlet var usernameText : UITextField?
    @IBOutlet var passwordText : UITextField?
    @IBOutlet var submitLogin  : UIButton?
    @IBOutlet var errorMessage : UILabel?

    // MARK: Base view functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // we are hiding the navigation bar to prevent users from moving away from the login view
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    // MARK: Supporting functions
    /**
     This function processes the login when the user presses a button.

     - Parameter sender: The reference to the UIButton initiating the function call.
    */
    @IBAction func processLogin(_ sender : UIButton) {
        
        var user:TWUser?
        
        do {
            
            // see if the user is able to login
            user = try TWComms().checkLogin(usernameText?.text ?? "", passwordText?.text ?? "")
            
            // now we should save the user to the keychain so we are able to "autosign-in"
            if let saveuser = user {
                if !KeychainWrapper.standard.set(saveuser, forKey: "TWUser") {
                    
                    // there was a problem saving the user in the keychain
                    user = nil
                    
                    // show the error
                    // change the username and password to red
                    usernameText?.backgroundColor = UIColor.red
                    passwordText?.backgroundColor = UIColor.red
                    
                    // display the message
                    errorMessage?.textColor = UIColor.red
                    errorMessage?.text = "There was a problem saving the user.  Please try again."

                } else {
                    // The save was successful
                    // show the rootviewcontroller now
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
        } catch let error as UserError {
            
            // lets se if this is the problem with the username and password
            if error == .UsernameOrPasswordIncorrect {
                
                // change the username and password to red
                usernameText?.backgroundColor = UIColor.red
                passwordText?.backgroundColor = UIColor.red
                
                // display the message
                errorMessage?.textColor = UIColor.red
                errorMessage?.text = "The Username Or Password Is Not Correct.  Please Try Again."
                
            }
            
        } catch {
            
            // there was some unknown type of error - display a generic error message
            errorMessage?.textColor = UIColor.red
            errorMessage?.text = "Not sure what is going on here.  Please try again, or contact support."

        }
    }
}

