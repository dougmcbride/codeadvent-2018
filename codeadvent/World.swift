import Foundation

struct ParseError: Error {
    let message: String

    init(_ s: String) {
        message = s
    }
}

struct World {
    private var entities: [WorldContent]
    var creatures: Set<Creature>
    let width, height: Int

    init(string: String) throws {
        let rows = string.split(separator: "\n")

        self.entities = try rows.reduce(into: [WorldContent](), { array, row in
            array.append(contentsOf: try row.trimmingCharacters(in: .whitespaces).map { (char: Character) -> WorldContent in
                switch char {
                case ".": return .empty
                case "E": return .creature(type: .elf)
                case "G": return .creature(type: .goblin)
                case "#": return .wall
                default: throw ParseError("Bad character '\(char)'")
                }
            })
        })

        self.height = rows.count
        self.width = rows.first!.trimmingCharacters(in: .whitespaces).count

        self.creatures = Set<Creature>()
        for (index, entity) in entities.enumerated() {
            if case .creature(let type) = entity {
                self.creatures.insert(Creature(type: type,
                                               position: Position(x: index % width, y: index / width)))
            }
        }
    }

    func shortestPath(from startPosition: Position, to targetPositions: Array<Position>) -> Path? {
        if targetPositions.isEmpty {
            return nil
        }

        var openPaths = Set<Path>([Path(start: startPosition)])
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
                    openPaths.formUnion(path.possiblePaths(within: self))
                    reachedPositions.insert(path.end)
                }

                openPaths.remove(path)
            }
        } while !openPaths.isEmpty

        return nil
    }

    subscript(position: Position) -> WorldContent {
        get {
            return entities[position.y * width + position.x]
        }
        set {
            entities[position.y * width + position.x] = newValue
        }
    }

    mutating func move(creature: Creature, on path: Path) {
        let entity = self[creature.position]
        self[creature.position] = .empty
        self[path.nextPosition] = entity
        creature.position = path.nextPosition
    }
    
    mutating func remove(creature: Creature) {
        self[creature.position] = .empty
        creatures.remove(creature)
    }
}

extension World: Collection {
    public var startIndex: Position {
        return Position(x: 0, y: 0)
    }

    public var endIndex: Position {
        return Position(x: width - 1, y: height - 1)
    }

    public func index(after i: Position) -> Position {
        let x = i.x + 1

        return x < width ?
            Position(x: x, y: i.y) :
            Position(x: 0, y: i.y + 1)
    }
}

extension World: CustomStringConvertible {
    public var description: String {
        return stride(from: 0, to: entities.count, by: width).map { rowStartIndex in
            let rowCreatureString = self.creatures
                .filter { $0.position.y == rowStartIndex / width }
                .sorted(by: { $0.position < $1.position })
                .map { $0.description }
                .joined(separator: ",")

            return entities[rowStartIndex..<rowStartIndex + width].map { $0.representation }.joined()
                   + "  "
                   + rowCreatureString
        }.joined(separator: "\n")
    }
}

