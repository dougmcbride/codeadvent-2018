import Foundation

enum Turn {
    case left, straight, right

    var next: Turn {
        switch self {
        case .left: return .straight
        case .straight: return .right
        case .right: return .left
        }
    }
}

struct Position: Hashable, Comparable {
    let x, y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    static func <(lhs: Position, rhs: Position) -> Bool {
        return lhs.y < rhs.y ||
               (lhs.y == rhs.y && lhs.x < rhs.x)
    }

    static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class DirectionError: Error {
}

class Cart: Hashable {
    private static var nextIndex = 0

    let id: Int
    var position: Position
    var direction: Direction
    var nextTurn = Turn.left

    init(position: Position, character: Character) {
        self.id = Cart.nextIndex
        Cart.nextIndex += 1
        self.position = position
        self.direction = Direction(rawValue: character)!
    }

    func turnAtJunction(junction: Junction) throws {
        let newDirection: Direction

        switch (junction, direction) {
        case (.slash, .north): newDirection = .east
        case (.slash, .east): newDirection = .north
        case (.slash, .west): newDirection = .south
        case (.slash, .south): newDirection = .west
        case (.backslash, .south): newDirection = .east
        case (.backslash, .west): newDirection = .north
        case (.backslash, .north): newDirection = .west
        case (.backslash, .east): newDirection = .south
        case (.junction, let d):
            newDirection = d.turn(nextTurn)
            nextTurn = nextTurn.next
        }

        direction = newDirection
    }

    func move() {
//        print("\(self) moves from \(position) to ", terminator: "")
        position = Position(position.x + direction.dx,
                            position.y + direction.dy)
//        print(position)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Cart: Equatable {
    public static func ==(lhs: Cart, rhs: Cart) -> Bool {
        return lhs.id == rhs.id
    }
}

enum Junction: Character, CaseIterable {
    case slash = "/"
    case backslash = "\\"
    case junction = "+"
}

enum Direction: Character, CaseIterable {
    case north = "^"
    case south = "v"
    case west = "<"
    case east = ">"

    func turn(_ turn: Turn) -> Direction {
        switch (self, turn) {
        case (.north, .right), (.south, .left), (.east, .straight): return .east
        case (.south, .right), (.north, .left), (.west, .straight): return .west
        case (.west, .left), (.east, .right), (.south, .straight): return .south
        case (.east, .left), (.west, .right), (.north, .straight): return .north
        }
    }

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

func main(carts initialCarts: [Cart], grid: [[Junction?]]) throws -> Position {
//    print(carts)
//    print(grid)
    var carts = Set<Cart>(initialCarts)
    
    while true {
        var cartDictionary: [Position: [Cart]] = Dictionary(grouping: carts, by: { $0.position })
       
        for cart in carts.sorted(by: { $0.position < $1.position }) {
            guard carts.contains(cart) else {
                continue
            }
            
            cart.move()
            
            if let crashedCart = cartDictionary[cart.position] {
                print("crash at \(cart.position)")
                carts.remove(crashedCart.first!)
                carts.remove(cart)
                continue
            }
            
            cartDictionary = Dictionary(grouping: carts, by: { $0.position })

            if let junction = grid[cart.position.y][cart.position.x] {
                try cart.turnAtJunction(junction: junction)
            }
        }

        if carts.count == 1 {
            print(carts.first!.direction)
            return carts.first!.position
        }
    }
}

let inputString = "/->-\\        \n|   |  /----\\\n| /-+--+-\\  |\n| | |  | v  |\n\\-+-/  \\-+--/\n  \\------/   "

//
//let input = inputString
//    .split(separator: "\n")
//    .map{Point.init(substring: $0)}

//var input = [Int]()
//var lines = [String]()
//

var width: Int
var y = 0
var grid = [[Junction?]]()

var carts = [Cart]()

while let line = readLine(strippingNewline: true) {
    var cells = [Junction?]()

    for (i, c) in line.enumerated() {
        switch c {
        case "<", ">", "^", "v":
            carts.append(Cart(position: Position(i, y), character: c))
            cells.append(nil)
        case "/", "\\":
            cells.append(Junction(rawValue: c))
        case "+":
            cells.append(.junction)
        default:
            cells.append(nil)
        }
    }
//    print(line)
//    print(cells)

    grid.append(cells)
    y += 1
}

try! print(main(carts: carts, grid: grid))
