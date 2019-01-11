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

    func shortestPath(to targetPositions: Array<Position>, in world: World) -> Path? {
        if targetPositions.isEmpty {
            return nil
        }

        var openPaths = Set<Path>([Path(start: self)])
        var reachedPositions = Set<Position>()

        repeat {
            for path in openPaths.sorted() {
                guard openPaths.contains(path), !reachedPositions.contains(path.end) else {
                    openPaths.remove(path)
                    continue
                }

                if targetPositions.contains(path.end) {
                    return path
                } else {
                    openPaths.formUnion(path.possiblePaths(within: world))
                    reachedPositions.insert(path.end)
                }

                openPaths.remove(path)
            }
        } while !openPaths.isEmpty

        return nil
    }
}

extension Position: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(x),\(y))"
    }
}
