//
//  TaskTableViewCell.swift
//  ToDoListApp
//
//  Created by shafique dassu on 21/02/2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    weak var delegate: ViewControllerDelegate?
    var index = 0 
    
    @IBAction func checkmarkButtonTapped(_ sender: Any) {
        print("cell was tapped")
        guard let viewController = delegate else {
            return
        }
        delegate?.toggleIsComplete(forindex: index)
    }
    
}
