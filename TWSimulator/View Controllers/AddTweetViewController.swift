//
//  AddTweetViewController.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/27/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit

/**
 View controller used to control adding tweets.
 
 This controller manages and maintains the process of adding the tweets.
 - Author: Mike Silvers
 - Date: 3/27/19
 */

class AddTweetViewController: UIViewController, UITextViewDelegate {

    //MARK: Variable declarations
    @IBOutlet var errorLabel: UILabel?
    @IBOutlet var tweetMessage: UITextView?
    @IBOutlet var submitButton:UIButton?
    @IBOutlet var cancelButton:UIButton?

    private let baseErrorLabel = "Please Enter Your Tweet:"
    
    // MARK: Base view functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // setup the base colors and configuration of the error label
        errorLabel?.backgroundColor = UIColor.clear
        errorLabel?.textColor = UIColor.black
        errorLabel?.text = baseErrorLabel
        
    }
    
    // MARK: Supporting functions
    /**
     This function processes the cancel when the user presses a button.
     
     If the user decides not to save a tweet, this function allows the user to cancel the tweet before it is saved.
     - Parameter sender: The reference to the UIButton initiating the function call.
     */
    @IBAction func cancelAction(_ sender: UIButton) {
    
        // we are going to dismiss the view - no changes
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /**
     This function processes the save tweet when the user presses a button.
     
     If the user decides to save a tweet, this function saves the tweet.
     - Parameter sender: The reference to the UIButton initiating the function call.
     */
    @IBAction func submitAction(_ sender: UIButton) {
        
        // lets check the field value to determine if we are saving it
        // we are makinbg sure there are characters in the tweet.  By removing the whitespaces for the test, we make sure there is something of substance in the tweet.
        if let t = tweetMessage?.text, !t.isEmpty, !(t.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty) {
            
            // lets save the tweet
            TWDataSource.shared.addMessage(Tweet(t))
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            // if there is an error in the user data entry (ie: no tweet), display the error.
            errorLabel?.backgroundColor = UIColor.red
            errorLabel?.textColor = UIColor.black
            errorLabel?.text = "Please add something to your Tweet - there is nothing here."
            
        }
    }
    
    //MARK: UITextViewDelegate functions
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // only allow 240 characters and backspaces
        if range.location >= 239, text != "" {
            
            // lets tell them the problem with the length of the tweet
            errorLabel?.backgroundColor = UIColor.yellow
            errorLabel?.textColor = UIColor.black
            errorLabel?.text = "Hey, hey - only 240 characters per Tweet."

            // do not allow them to add more characters
            return false
        }
        
        // make the error label is presenting the correct message for normal use (no errors)
        if let erl = errorLabel?.text, erl != baseErrorLabel {
            errorLabel?.backgroundColor = UIColor.clear
            errorLabel?.textColor = UIColor.black
            errorLabel?.text = baseErrorLabel
        }
        
        // allow all other characters
        return true
        
    }
}
