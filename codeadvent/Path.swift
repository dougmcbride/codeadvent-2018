import Foundation

struct Path: Comparable, Hashable, Equatable {
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
            .filter { world[$0.end].isTraversable }
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

        if lhs.end != rhs.end {
            return lhs.end < rhs.end
        }
        
        for i in lhs.positions.indices {
            if lhs.positions[i] != rhs.positions[i] {
                return lhs.positions[i] < rhs.positions[i]
            }
        }

//        print(lhs)
//        print(rhs)
        return false
    }
}
