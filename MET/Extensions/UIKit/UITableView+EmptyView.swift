//
//  UITableView+EmptyView.swift
//  MET
//
//  Created by Django on 3/7/22.
//

import UIKit

extension UITableView {
    /// show an empty view for a tableview
    /// - Parameter message: the msg to show
    public func showEmptyViewWith(message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        backgroundView = messageLabel
        separatorStyle = .none
    }

    /// hide the empty view
    public func hideEmptyView() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
