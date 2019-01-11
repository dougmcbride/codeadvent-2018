import Foundation

struct ParseError: Error {
    let message: String

    init(_ s: String) {
        message = s
    }
}

struct World {
    private var contents: [WorldContent]
    private let width, height: Int

    var creatures: Set<Creature>

    init(string: String) throws {
        let rows = string.split(whereSeparator: { CharacterSet.whitespacesAndNewlines.contains($0.unicodeScalars.first!) })

        self.contents = try rows.reduce(into: [WorldContent](), { array, row in
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

        for (index, entity) in contents.enumerated() {
            if case .creature(let type) = entity {
                self.creatures.insert(Creature(type: type,
                                               position: Position(x: index % width, y: index / width)))
            }
        }
    }

    var creatureTypeCount: Int {
        return Dictionary(grouping: creatures, by: { $0.type }).keys.count
    }

    subscript(position: Position) -> WorldContent {
        get {
            return contents[position.y * width + position.x]
        }
        set {
            contents[position.y * width + position.x] = newValue
        }
    }

    mutating func move(creature: Creature, on path: Path) {
        let worldContent = self[creature.position]
        self[creature.position] = .empty
        self[path.nextPosition] = worldContent
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
        return stride(from: 0, to: contents.count, by: width).map { rowStartIndex in
            let rowCreatureString = self.creatures
                .filter { $0.position.y == rowStartIndex / width }
                .sorted(by: { $0.position < $1.position })
                .map { $0.description }
                .joined(separator: ",")

            return contents[rowStartIndex..<rowStartIndex + width].map { $0.representation }.joined()
                   + "  "
                   + rowCreatureString
        }.joined(separator: "\n")
    }
}

