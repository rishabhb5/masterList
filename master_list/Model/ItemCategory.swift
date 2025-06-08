// 20250605
// Item Category Enum

import Foundation
import SwiftUI // needed for Color

enum ItemCategory: String, CaseIterable, Codable {
    case work = "Work"
    case personal = "Personal"
    
    var color: Color {
        switch self {
            
        case .work:
            return .blue
        case .personal:
            return .purple
            
        }
    }
    
    var icon: String {
        switch self {
            
        case .work:
            return "briefcase.fill"
        case .personal:
            return "person.fill"
            
        }
    }
    
}
