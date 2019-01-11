import Foundation

enum Direction: CaseIterable {
    case north, south, east, west

    var dx: Int {
        switch self {
        case .north, .south: return 0
        case .west: return -1
        case .east: return 1
        }
    }

    var dy: Int {
        switch self {
        case .east, .west: return 0
        case .north: return -1
        case .south: return 1
        }
    }
}
