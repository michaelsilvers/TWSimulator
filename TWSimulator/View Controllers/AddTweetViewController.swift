//
//  AddTweetViewController.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/27/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit

class AddTweetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var errorLabel: UILabel?
    @IBOutlet var tweetMessage: UITextField?
    @IBOutlet var submitButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        // lets check the field value to determine if we are saving it
        if let t = tweetMessage?.text, !t.isEmpty {
            
            // lets save the tweet
            TWDataSource.shared.addMessage(Tweet(t))
            
        } else {
            
            
            
        }
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
