import Foundation

struct Tree {
    let root: Node
}

class Node: Hashable, Named {
    private static var id = 0

    let id: Int
    let size: Int
    let metadata: [Int]
    let children: [Node]

    var name: String {
        return String(id)
    }

    var duration: Int {
        return 60 + Int(Unicode.Scalar(name)!.value - Unicode.Scalar("A")!.value + 1)
    }

    init(data: Array<Int>) {
        self.id = Node.id
        Node.id += 1

        var size = 2

        let childCount = data[0]
        let metadataCount = data[1]

        var children = [Node]()
        for _ in 0..<childCount {
            let child = Node(data: data[size...])
            children.append(child)
            size += child.size
        }
        self.children = children

        self.size = size + metadataCount

        self.metadata = Array(data[size..<self.size])
    }

    convenience init(data: ArraySlice<Int>) {
        self.init(data: Array(data))
    }

    var metadataSum: Int {
        return metadata.reduce(0, +) + children.reduce(into: 0) { $0 += $1.metadataSum }
    }

    var value: Int {
        let empty = children.isEmpty
        return empty ?
            metadataSum :
            metadata.reduce(into: 0) { result, childIndex in
                if (children.startIndex..<children.endIndex).contains(childIndex - 1) {
                    result += children[childIndex - 1].value
                }
            }
    }
}

protocol Named: CustomStringConvertible, Hashable {
    var name: String { get }
}

extension Named {
    public var description: String {
        return name
    }

    var hashValue: Int {
        return name.hashValue
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}

func main(data: [Int]) -> Int {
    let rootNode = Node(data: data)
    return rootNode.value
}

//let inputString = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

//let input = inputString
//    .split(separator: " ")
//    .map { Int($0)! }

var input = [Int]()
//var lines = [String]()
//
while let line = readLine(strippingNewline: true) {
    input.append(contentsOf: line.split(separator: " ").map { Int($0)! })
}

print(main(data: input))
