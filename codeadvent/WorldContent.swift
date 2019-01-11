import Foundation

enum WorldContent: Equatable {
    case empty
    case wall
    case creature(type: CreatureType)

    var representation: String {
        switch self {
        case .empty: return " "
        case .wall: return "#"
        case .creature(let type):
            switch type {
            case .elf: return "E"
            case .goblin: return "G"
            }
        }
    }

    var isTraversable: Bool {
        return self == .empty
    }
}
