//
//  AddTweetViewController.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/27/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit

class AddTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var errorLabel: UILabel?
    @IBOutlet var tweetMessage: UITextView?
    @IBOutlet var submitButton:UIButton?
    @IBOutlet var cancelButton:UIButton?

    private let baseErrorLabel = "Please Enter Your Tweet:"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        errorLabel?.backgroundColor = UIColor.clear
        errorLabel?.textColor = UIColor.black
        errorLabel?.text = baseErrorLabel
        
    }
    @IBAction func cancelAction(_ sender: UIButton) {
    
        // we are going to dismiss the view - no changes
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        // lets check the field value to determine if we are saving it
        if let t = tweetMessage?.text, !t.isEmpty {
            
            // lets save the tweet
            TWDataSource.shared.addMessage(Tweet(t))
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            errorLabel?.backgroundColor = UIColor.red
            errorLabel?.textColor = UIColor.black
            errorLabel?.text = "Please add some words to your Tweet - there is nothing."
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // only allow 240 characters and backspaces
        if range.location >= 239, text != "" {
            
            // lets tell them the problem
            errorLabel?.backgroundColor = UIColor.yellow
            errorLabel?.textColor = UIColor.black
            errorLabel?.text = "Hey, hey - only 240 characters per Tweet."

            return false
        }
        
        // make sure the label has the correct words....
        if let erl = errorLabel?.text, erl != baseErrorLabel {
            errorLabel?.backgroundColor = UIColor.clear
            errorLabel?.textColor = UIColor.black
            errorLabel?.text = baseErrorLabel
        }
        
        // allow all other characters
        return true
        
    }
}
