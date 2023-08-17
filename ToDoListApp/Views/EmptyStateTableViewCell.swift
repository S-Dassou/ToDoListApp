//
//  EmptyStateTableViewCell.swift
//  ToDoListApp
//
//  Created by shafique dassu on 09/04/2023.
//

import UIKit
import Lottie

class EmptyStateTableViewCell: UITableViewCell {

    
    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animationView.animation = LottieAnimation.named("TaskMan")
        animationView.loopMode = .loop
        animationView.play()
    }

   
    }


