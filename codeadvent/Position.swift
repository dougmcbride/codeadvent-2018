import Foundation

protocol Positioned {
    var position: Position { get }
}

struct Position: Hashable, Comparable {
    let x, y: Int

    func move(_ direction: Direction) -> Position {
        return Position(x: x + direction.dx,
                        y: y + direction.dy)
    }

    static func <(lhs: Position, rhs: Position) -> Bool {
        return lhs.y != rhs.y ?
            lhs.y < rhs.y :
            lhs.x < rhs.x
    }

    var adjacentPositions: [Position] {
        return Direction.allCases.map { move($0) }
    }

    func distance(from: Position) -> Int {
        return abs(x - from.x) + abs(y - from.y)
    }
}

extension Position: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(x),\(y))"
    }
}
