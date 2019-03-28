//
//  MessagesTableViewController.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MessagesTableViewController: UITableViewController {

    private var tweets: [Tweet] = []
    private var readDateFormat = DateFormatter()
    private var createdDateFormat = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // we only need to set these one time - yup - one time
        readDateFormat.dateFormat = "'Read:' MM/dd/yyyy HH:mm"
        createdDateFormat.dateFormat = "MM/dd/yyyy HH:mm"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // make sure the navigation bar is present
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // fill the tweet array from the data source
        tweets = TWDataSource.shared.getMessages()
        self.tableView.reloadData()
        
    }

    // MARK: Supporting functions
    @IBAction func logoutUser(_ sender: Any) {
        
        // destroy the user in the keychain
        // in the future we would deal with the error here (the remove is returning a bool)
        KeychainWrapper.standard.removeObject(forKey: "TWUser")
        
        // go back to the login screen
        navigationController?.performSegue(withIdentifier: "LoginSegue", sender: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // we are only having one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell)

        // Configure the cell...
        var tweet = tweets[indexPath.row]

        // put together the read time screen
        if let rt = tweet.readTimeDate, rt > 0 {
            // we read the tweet
            cell.readIndicator?.isHidden = false
            let readD = Date(timeIntervalSince1970: Double(rt))
            cell.readLabel?.text = readDateFormat.string(from: readD)
        } else {
            // we didn't read the tweet
            cell.readIndicator?.isHidden = true
            cell.readLabel?.text = ""
            // and update the tweet with the read date time
            tweet.readTimeDate = Int(Date().timeIntervalSince1970)
            // update the tweet with the new read date
            TWDataSource.shared.addMessage(tweet)
        }
        
        // set the other tweet information
        cell.messageLabel?.text = tweet.message
        cell.sentLabel?.text = createdDateFormat.string(from: Date(timeIntervalSince1970: Double(tweet.createdTimeDate)))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
