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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryContainerView: UIView!
    
    weak var delegate: ViewControllerDelegate?
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.clipsToBounds = true
        categoryContainerView.backgroundColor = UIColor.link.withAlphaComponent(0.5)
        categoryLabel.textColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.cornerRadius = 5
        categoryContainerView.layer.cornerRadius = categoryContainerView.frame.height / 2
    }
    
    
    @IBAction func checkmarkButtonTapped(_ sender: Any) {
        print("cell was tapped")
        delegate?.toggleIsComplete(forindex: index)
    }
}
    

