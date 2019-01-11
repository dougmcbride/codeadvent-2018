import Foundation

struct Path: Comparable, Hashable {
    let positions: [Position]

    var length: Int {
        return positions.count
    }

    var isEmpty: Bool {
        return positions.count == 1
    }

    var end: Position {
        return positions.last!
    }

    var nextPosition: Position {
        return positions[1]
    }

    func possiblePaths(within world: World) -> [Path] {
        return Direction.allCases
            .map { Path(path: self, direction: $0) }
            .filter { world[$0.end].isEmpty }
    }

    init(start: Position) {
        self.positions = [start]
    }

    init(path: Path, direction: Direction) {
        self.positions = path.positions + [path.end.move(direction)]
    }

    static func <(lhs: Path, rhs: Path) -> Bool {
        if lhs.length != rhs.length {
            return lhs.length < rhs.length
        }

        for i in lhs.positions.indices {
            if lhs.positions[i] != rhs.positions[i] {
                return lhs.positions[i] < rhs.positions[i]
            }
        }

        return false
    }
}
