//
//  FirstPageTableViewCell.swift
//  MET
//
//  Created by Django on 3/7/22.
//

import UIKit

/// tableView cell for firstPage vc
public final class FirstPageTableViewCell: UITableViewCell {
    @IBOutlet private weak var _objectIdLabel: UILabel!

    /// set the model
    public var objectId: Int? {
        didSet {
            _objectIdLabel.text = objectId?.stringValue
        }
    }

    /// change this for a different background color
    public var isEven: Bool = false {
        didSet {
            backgroundColor = isEven ? .lightGray : .cyan
        }
    }
}

// MARK: - life cycle
extension FirstPageTableViewCell {
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
