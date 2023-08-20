import Foundation
import UIKit

enum Category: String, CaseIterable {
    case gym = "fitness", hobby = "hobby", work = "work"
    
    var color: UIColor {
        switch self {
        case .gym:
            return UIColor.fitness
        case .hobby:
            return UIColor.hobby
        case .work:
            return UIColor.work
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .gym:
            return UIColor.secondaryFitness
        case .hobby:
            return UIColor.secondaryHobby
        case .work:
            return UIColor.secondaryWork
        }
    }
}
