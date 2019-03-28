//
//  MessageTableViewCell.swift
//  TWSimulator
//
//  Created by Mike Silvers on 3/25/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit

/**
 View controller used to control the display and functionality for the individual tweet cells.
 
 This controller manages and maintains the display of the individual tweet cells.
 - Author: Mike Silvers
 - Date: 3/25/19
 */

class MessageTableViewCell: UITableViewCell {

    // MARK: Variable declarations
    @IBOutlet var readIndicator: UIImageView?
    @IBOutlet var messageLabel: UILabel?
    @IBOutlet var readLabel: UILabel?
    @IBOutlet var sentLabel: UILabel?
    
}
