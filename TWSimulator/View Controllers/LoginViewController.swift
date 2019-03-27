//
//  ViewController.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var usernameText : UITextField?
    @IBOutlet var passwordText : UITextField?
    @IBOutlet var submitLogin  : UIButton?
    @IBOutlet var errorMessage : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // we are hiding the navigation bar to prevent users from moving away from the login view
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    @IBAction func processLogin(_ sender : UIButton) {
        
        var user:TWUser? = nil
        
        do {
            
            // see if the user is able to login...
            user = try TWComms().checkLogin(usernameText?.text ?? "", passwordText?.text ?? "")
            
            // now we should save the user to the keychain so we are able to "autosign-in"
            
            
            // show the rootviewcontroller now
            self.navigationController?.popToRootViewController(animated: true)
            
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

