//
//  UIColor.swift
//  ToDoListApp
//
//  Created by shafique dassu on 19/08/2023.
//

import Foundation
import UIKit

extension UIColor {
    
    static var work: UIColor {
        return UIColor(named: "Work")!
    }
    static var hobby: UIColor {
        return UIColor(named: "Hobby")!
    }
    static var fitness: UIColor {
        return UIColor(named: "Fitness")!
    }
    static var secondaryWork: UIColor {
        return UIColor(named: "Work")!.withAlphaComponent(0.2)
    }
    static var secondaryHobby: UIColor {
        return UIColor(named: "Hobby")!.withAlphaComponent(0.2)
    }
    static var secondaryFitness: UIColor {
        return UIColor(named: "Fitness")!.withAlphaComponent(0.2)
    }
}
