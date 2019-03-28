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
    
    //MARK: Reading/Writing from documents
    // Based on: https://github.com/MakeAppPiePublishing/Tips_02_Read_Write_Text_End
    private var DocumentDirURL:URL{
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url
    }
    
    private func fileURL(_ fileName:String,_ fileExtension:String="json")-> URL{
        
        return DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
        
    }
    
    func writeFile(_ writeString:String,_ fileName:String,_ fileExtension:String = "json") {
        let url = fileURL(fileName, fileExtension)
        do{
            try writeString.write(to: url, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            print ("Failed writing to URL: \(String(describing: fileURL)), Error:" + error.localizedDescription)
        }
    }
    
    func readFile(_ fileName:String,_ fileExtension:String = "json") -> String {
        var readString = ""
        let url = fileURL(fileName, fileExtension)
        do{
            readString = try String(contentsOf: url)
        } catch let error as NSError {
            print ("Failed writing to URL: \(String(describing: fileURL)), Error:" + error.localizedDescription)
        }
        return readString
    }
    // End of the reference (https://github.com/MakeAppPiePublishing/Tips_02_Read_Write_Text_End)
    
    func fileExists(_ fileName:String,_ fileExtension:String = "json") -> Bool {
        
        var retBool = false
        
        let url = fileURL(fileName, fileExtension)
        
        retBool = FileManager.default.fileExists(atPath: url.absoluteString)
        
        return retBool
    }
    
    @discardableResult func removeFile(_ fileName:String,_ fileExtension:String = "json") -> Bool {
        
        var retBool = false
        
        let url = fileURL(fileName, fileExtension)
        
        do {
            try FileManager.default.removeItem(at: url)
            retBool = true
        } catch {
            // do nothing - retBool is defaulted to false
        }
        
        return retBool
    }

    // we are using a singleton so there is only one datasource for the entire project
    static let shared = TWDataSource()
    
    // Initialization for the singleton
    private init() {
        
        // at the initial initilization, lets load the JSON file from the Documents directory - if it exists
        if fileExists("tw_messages"), let jsonData = readFile("tw_messages").data(using: .utf8) {
            
            do {
                
                // lets decode the json
                messages = try JSONDecoder().decode([Tweet].self, from: jsonData)
                
            } catch {
                print("There was an error when decoding the json.  The error is \(error.localizedDescription)")
            }
            
        }
        
    }
    
    func saveMessages() {
        
        // only save the json if there are messages in the array
        if messages.count > 0 {
            do {
                if let writeme = String(data:try JSONEncoder().encode(messages), encoding: .utf8) {
                    let url = fileURL("tw_messages")
                    try writeme.write(to: url, atomically: true, encoding: .utf8)
                }
            } catch {
                print("There was an error when encoding the json.  The error is \(error.localizedDescription)")
            }
        }
        
    }
    
    @discardableResult func getMessages(_ fromDate: Int = 0) -> [Tweet] {
        
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
        
        // lets write the new stuff to the directory since things changed
        TWDataSource.shared.saveMessages()
        
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
        
        // delete the saved messages in the documents directory
        removeFile("tw_messages")
        
    }
    
}
