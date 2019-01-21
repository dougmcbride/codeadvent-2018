import Foundation

protocol Positioned {
    var position: Position { get }
}

struct Position: Hashable, Comparable, Equatable {
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

    func shortestPath(to targetPositions: Array<Position>, in world: World) -> Path? {
        if targetPositions.isEmpty {
            return nil
        }

        var openPaths = Set<Path>([Path(start: self)])
        var reachedPositions = Set<Position>()
        var bestPath: Path?

        while !openPaths.isEmpty {
            for path in openPaths.sorted() {
                guard openPaths.contains(path) else {
                    continue
                }

                openPaths.remove(path)

                if bestPath != nil && path > bestPath! {
                    continue
                }

                if reachedPositions.contains(path.end) {
                    continue
                }

                reachedPositions.insert(path.end)

                if targetPositions.contains(path.end) {
                    if bestPath == nil || path < bestPath! {
                        bestPath = path
                    }
                } else {
                    openPaths.formUnion(path.possiblePaths(within: world))
                }
            }
        }

        return bestPath
    }
}

extension Position: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(x),\(y))"
    }
}
