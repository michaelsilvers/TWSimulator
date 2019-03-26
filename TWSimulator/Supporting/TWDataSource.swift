//
//  TWDataSource.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/26/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

class TWDataSource {

    private var messages: [Tweet] = []

    // we are using a singleton so there is only one datasource for the entire project
    static let shared = TWDataSource()
    
    // Initialization for the singleton
    private init() {  }
    
    func getMessages(_ fromDate: Int = 0) -> [Tweet] {
        
        if fromDate == 0 {
            // there was no date passed in - we will return all  of the messages
            return messages.sorted(by: { $0.createdTimeDate > $1.createdTimeDate })
        } else {
            // lets return the messages that are after the from date
            let m = messages.filter { $0.createdTimeDate >= fromDate }
            return m.sorted(by: { $0.createdTimeDate > $1.createdTimeDate } )
        }
    }
    
    func nextIdNumber() -> Int {
        
        var thenumber = 0
        
        // check to see if there are more than 1 messages in the array (because of the sort)
        if messages.count > 1,
            let maxmessage = messages.max(by: { (a,b) -> Bool in
                return a.messageId < b.messageId
            }) {
            
            // we pulled the Tweet that has the highest max number, now lets process it
            thenumber = maxmessage.messageId
            
        // check to see if there is only one Tweet in the array
        } else if messages.count == 1, let testt = messages.first {
            
            // the ID is the number from the only Tweet in the picture here
            thenumber = testt.messageId
        }
        
        // increment the ID so we are using the next number
        thenumber += 1
        
        return thenumber
    }
    
    
    func addMessage(_ newMessage: Tweet) {
        
        // do we have a number already?
        if newMessage.messageId == 0 {
            // if not, we know this is a new entry - so just add it after assigning the ID
            var nm = newMessage
            nm.messageId = self.nextIdNumber()
            messages.append(nm)
        } else {
            // check to see if the Tweet is in the array already - if so, update it, if not, add it
            if messages.contains(where: { $0.messageId == newMessage.messageId }) {
                
                // replace the existing with the updated
                if let array_place = messages.firstIndex(where: { $0.messageId == newMessage.messageId }) {
                    messages.remove(at: array_place)
                    messages.insert(newMessage, at: array_place)
                }
                
            } else {
                // this one is new!
                messages.append(newMessage)
            }
        }
    }
    
    func getSingleTweet(_ tweetId: Int) -> Tweet? {
        
        // if there is a tweet with the ID, lets return the Tweet
        let m = messages.filter({ $0.messageId == tweetId })
        if let mr = m.first { return mr }
    
        // there are no records with that ID
        return nil
    }
    
    func clearAllMessages() {
        messages.removeAll()
    }
    
    private func loadMessages() {
        
        // if we were hitting an API, this is where we would access the API for
        // past messages - but - since we are not using an API, we are saving
        // messages in a json file in the documents directory for this app.
        
        
    }
}
