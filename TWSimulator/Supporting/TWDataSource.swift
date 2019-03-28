//
//  TWDataSource.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/26/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import Foundation

/**
 The data source controls the tweet array and allows other processes to access the tweet array.
 
 When tweets are added or updated in the array, the list is saved in a JSON file in the users documents directory.  This allows for the immediate update of all tweets whenever there are changes.  This approach was taken due to the expected use of the app.
 
 If the volume increases *OR* if we connect the app to a RESTful API, CoreData or Realm would be an approariate integration rather than a JSON file in the documents directory.
 
 - Note: This class is **NOT** threadsafe.
 
 The documents directory is saved during backups, so the tweet list is saved during the normal iOS backup process.
 - Author: Mike Silvers
 - Date: 3/26/19
 */

class TWDataSource {

    //MARK: Variable definitions
    private var messages: [Tweet] = []
    
    /**
     The dynamic variable retrieves the user documents directory.
     
     - NOTE: These functions and variables are based on the open source functions found here:  https://github.com/MakeAppPiePublishing/Tips_02_Read_Write_Text_End
 */
    private var DocumentDirURL:URL{
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return url
    }
    
    //MARK: Reading/Writing from documents

    /**
     This *private* function retrieves the URL object for a specific file.
     
     This function returns the defined URL object for the specified file.  It also sets the default extension as a JSON docum ent.
     
     - Parameter fileName: The name of the target file
     - Parameter fileExtension: An *optional* file extension.  The default file extension is `.json`.
     - Returns: A `URL` object defining the file.
    */
    private func fileURL(_ fileName:String,_ fileExtension:String="json")-> URL{
        
        return DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    }
    
    /**
     This function writes data to the file specified in the parameters.
     
     This function will write data to the file specified in the parameters.
     
     - Parameter writeString: The data to be written to the target file
     - Parameter fileName: The name of the file to be written to.
     - Parameter fileExtension: An *optional* file extension.  The default file extension is `.json`.
     */
    func writeFile(_ writeString:String,_ fileName:String,_ fileExtension:String = "json") {
        // grab the file url -- first thing
        let url = fileURL(fileName, fileExtension)
        do{
            // write the actual data
            try writeString.write(to: url, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            // there was an error - we just write to the log - we do not do anything else at thos point
            print ("Failed writing to URL: \(String(describing: fileURL)), Error:" + error.localizedDescription)
        }
    }
    
    /**
     This function reads data to the file specified in the parameters.
     
     This function will read data from the file specified in the parameters.
     
     - Note: This only works with text based files.
     
     - Parameter fileName: The name of the file to be read from.
     - Parameter fileExtension: An *optional* file extension.  The default file extension is `.json`.
     - Returns: A `String` containing the file contents
     */
    func readFile(_ fileName:String,_ fileExtension:String = "json") -> String {
        
        
        var readString = ""
        
        // grab the file URL
        let url = fileURL(fileName, fileExtension)
        do{
            // read the actual file
            readString = try String(contentsOf: url)
        } catch let error as NSError {
            // if there was a problem reading the file, we are not doing anything except writing to the console
            print ("Failed writing to URL: \(String(describing: fileURL)), Error:" + error.localizedDescription)
        }
        
        // return the info we just read
        return readString
    }
    // End of the reference (https://github.com/MakeAppPiePublishing/Tips_02_Read_Write_Text_End)
    
    /**
     This function determines if the file specified in the parameters exists.
     
     This function will determine if the file specified in the parameters actually exists.
     
     - Parameter fileName: The name of the file to be checked.
     - Parameter fileExtension: An *optional* file extension.  The default file extension is `.json`.
     - Returns: A `Bool` indicating if the file exists.  **true** indicates that the file exists.  **false** indicates that the file does not exist.
     */
    func fileExists(_ fileName:String,_ fileExtension:String = "json") -> Bool {
        
        var retBool = false
        
        // grab the URL for the file we are testing
        let url = fileURL(fileName, fileExtension)
        
        // does it exist?
        retBool = FileManager.default.fileExists(atPath: url.relativePath)
        
        return retBool
    }
    
    /**
     This function deletes the file specified in the parameters.
     
     This function will delete the file specified in the parameters.
     
     - Note: The result is discardable - you will not receive a warning if you do nothing with the returned `Bool`.
     
     - Parameter fileName: The name of the file to be deleted.
     - Parameter fileExtension: An *optional* file extension.  The default file extension is `.json`.
     - Returns: A `Bool` indicating the success of the deletion.  **true** indicates that the file was successfully deleted.  **false** indicates that the file was not deleted.
     */
    @discardableResult func removeFile(_ fileName:String,_ fileExtension:String = "json") -> Bool {
        
        var retBool = false
        
        // grab the URL for the file
        let url = fileURL(fileName, fileExtension)
        
        do {
            // do the delete
            try FileManager.default.removeItem(at: url)
            retBool = true
        } catch {
            // do nothing - retBool is defaulted to false
        }
        
        return retBool
    }

    // MARK: Singleton definition and creation
    // we are using a singleton so there is only one datasource for the entire project
    static let shared = TWDataSource()
    
    /**
     This *private* initializer is used for the creation of the singleton.
     
     We are using a singleton pattern because we only want one instance of this class in memory at any time.  The initializer is *private* to avoid developers creating another instance inadvertently.

     When the class is initialized, we will read the `tw_messages.json` file to determine if there are any messages in the `Documents` directory.  This is the initial load of the data.
     */
    private init() {
        
        // at the initial initilization, lets load the JSON file from the Documents directory - if it exists
        if fileExists("tw_messages"), let jsonData = readFile("tw_messages").data(using: .utf8) {
            
            do {
                
                // lets decode the json
                messages = try JSONDecoder().decode([Tweet].self, from: jsonData)
                
            } catch {
                // there was an error when decoding the file (it is JSON) - don't do anything except write to the console
                print("There was an error when decoding the json.  The error is \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: Functions to manage the datasource
    /**
     This function saves the messages to the default `json` file.
     
     This function saves the messages to the default file `tw_messages` in the users `Documents` directory.
     
     The messages written are the messages in the `private` messages array.
     
     */
    func saveMessages() {
        
        // only save the json if there are messages in the array
        if messages.count > 0 {
            do {
                // write the contents of the messages array to the default file
                if let writeme = String(data:try JSONEncoder().encode(messages), encoding: .utf8) {
                    let url = fileURL("tw_messages")
                    try writeme.write(to: url, atomically: true, encoding: .utf8)
                }
            } catch {
                print("There was an error when encoding the json.  The error is \(error.localizedDescription)")
            }
        }
        
    }
    
    /**
     This function returns an array of the `Tweet` objects.
     
     This function will return the `Tweet` objects from the datasource.  It allows a time parameter to filter the results returned.
     
     - Note: The result is discardable - you will not receive a warning if you do nothing with the returned `Array`.
     
     - Parameter fromDate: This is an *optional* parameter.  The date/time in *Epoch* format.  The messages greater than (**not** equal to) the date will be returned. If no date/time is passed, all messages are returned.
     - Returns: An `Array` of `Tweet` objects.
     */
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
    
    /**
     This function returns the next `ID` number.
     
     This function will return the next incremental `ID` number available.  The `ID` numbers are unique and incremental dependent upon the maximum `ID` number in the datasource.
     
     - Returns: An `Int` as the next available `ID` number.
     */
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
    
    /**
     This function adds or updates a `Tweet`.
     
     This function performs two functions:

     - **Adding** a new `Tweet`: if the `Tweet` does not exist, a new `ID` is assigned and the `Tweet` is added to the datasource.
     - **Updating** an existing `Tweet`: If the `Tweet` exists, as identified by the `ID` number, the values of the `Tweet` are updated. the information updated are the message and read date.
     
     - Note: the `ID` number determines if the `Tweet` exists.
     
     - Parameter newMessage: the `Tweet` to be added or updated.
     */
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
    
    /**
     This function retrieves a single `Tweet`.
     
     This function returns a single `Tweet` if it exists.
     
     - Note: the `ID` number determines if the `Tweet` exists.
     
     - Parameter tweetId: the `ID` of the `Tweet` to be returned.
     - Returns: The requested `Tweet` if it exists.  Returns *nil* if the `Tweet` does not exist in the datasource.
     */
    func getSingleTweet(_ tweetId: Int) -> Tweet? {
        
        // if there is a tweet with the ID, lets return the Tweet
        let m = messages.filter({ $0.messageId == tweetId })
        if let mr = m.first { return mr }
    
        // there are no records with that ID
        return nil
    }
    
    /**
     This function clears all messages from the datasource.
     
     This function clears all `Tweet` items from the datasource and removes the default file from the `Documents` directory.
     
     - Warning: **ALL** messages are removed - both from the datasource **AND** from the file system.
     
     */
    func clearAllMessages() {
        messages.removeAll()
        
        // delete the saved messages in the documents directory
        removeFile("tw_messages")
        
    }
    
}
