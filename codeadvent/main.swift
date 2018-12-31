import Foundation

class Node: Hashable, Named {
    let name: String
    var children = [Node]()

    var duration: Int {
        return 60 + Int(Unicode.Scalar(name)!.value - Unicode.Scalar("A")!.value + 1)
    }

    init(name: String) {
        self.name = name
    }

    func addChild(_ parent: Node) {
        children.append(parent)
    }

    func isParent(of maybeChildNode: Node) -> Bool {
        return children.contains(maybeChildNode)
    }

    func isAncestor(of maybeChildNode: Node) -> Bool {
        return isParent(of: maybeChildNode) ||
               children.reduce(into: false) { result, testNode in
                   let ancestor = testNode.isAncestor(of: maybeChildNode)
                   result = result || ancestor
               }
    }
}

extension Set where Element: Node {
    var allChildren: Set<Node> {
        return Set<Node>(flatMap { $0.children })
    }
}

extension Node: Comparable {
    public static func <(lhs: Node, rhs: Node) -> Bool {
        if rhs.isAncestor(of: lhs) {
            return false
        } else if lhs.isAncestor(of: rhs) {
            return true
        } else {
            return lhs.name < rhs.name
        }
    }
}

class Worker: Hashable, Named {
    let name: String
    var currentNode: Node?
    var finishTime = 0

    init(_ name: String) {
        self.name = name
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

private func parseNodes(lines: [String]) -> [String: Node] {
    var nodeMap = [String: Node]()

    for line in lines {
        let words = line.components(separatedBy: " ")
        let parentName = words[1]
        let childName = words[7]

        let parentNode = nodeMap[parentName] ?? Node(name: parentName)
        let childNode = nodeMap[childName] ?? Node(name: childName)
        parentNode.addChild(childNode)

        nodeMap[parentName] = parentNode
        nodeMap[childName] = childNode
    }
    return nodeMap
}

func main(lines: [String]) -> Int {
    var nodeMap = parseNodes(lines: lines)

    var remainingNodes = Set<Node>(nodeMap.values)

    let allWorkers = Set<Worker>((0..<5).map { Worker(String($0)) })
    var availableWorkers = allWorkers

    var result: Int?

    for time in 0..<Int.max {
        for worker in allWorkers {
            guard let node = worker.currentNode,
                  worker.finishTime == time else {
                continue
            }

            print("\(time): \(worker) finishes \(node)")
            remainingNodes.remove(node)
            worker.currentNode = nil
            availableWorkers.insert(worker)
        }

        if remainingNodes.isEmpty {
            result = time
            break
        }

        let children = remainingNodes.allChildren

        for worker in availableWorkers {
            let readyNodes = remainingNodes.filter { !children.contains($0) && !allWorkers.map { $0.currentNode }.contains($0) }

            guard let nextNode = readyNodes.sorted().first else {
                // No more tasks available
                break
            }

            // remainingNodes.remove(nextNode)

            worker.currentNode = nextNode
            worker.finishTime = time + nextNode.duration
            availableWorkers.remove(worker)

            print("\(time): \(worker) starts \(nextNode)")
        }
    }

    return result ?? -1
}

//let lines = [
//    "Step C must be finished before step A can begin.",
//    "Step C must be finished before step F can begin.",
//    "Step A must be finished before step B can begin.",
//    "Step A must be finished before step D can begin.",
//    "Step B must be finished before step E can begin.",
//    "Step D must be finished before step E can begin.",
//    "Step F must be finished before step E can begin.",
//]

let lines =
    "Step S must be finished before step C can begin.\nStep C must be finished before step R can begin.\nStep L must be finished before step W can begin.\nStep V must be finished before step B can begin.\nStep P must be finished before step Y can begin.\nStep M must be finished before step B can begin.\nStep Y must be finished before step J can begin.\nStep W must be finished before step T can begin.\nStep N must be finished before step I can begin.\nStep H must be finished before step O can begin.\nStep O must be finished before step T can begin.\nStep Q must be finished before step X can begin.\nStep T must be finished before step K can begin.\nStep A must be finished before step D can begin.\nStep G must be finished before step K can begin.\nStep D must be finished before step X can begin.\nStep R must be finished before step J can begin.\nStep U must be finished before step B can begin.\nStep K must be finished before step J can begin.\nStep B must be finished before step J can begin.\nStep J must be finished before step E can begin.\nStep E must be finished before step Z can begin.\nStep F must be finished before step I can begin.\nStep X must be finished before step Z can begin.\nStep Z must be finished before step I can begin.\nStep E must be finished before step F can begin.\nStep R must be finished before step I can begin.\nStep L must be finished before step Z can begin.\nStep N must be finished before step O can begin.\nStep O must be finished before step D can begin.\nStep K must be finished before step I can begin.\nStep R must be finished before step F can begin.\nStep T must be finished before step F can begin.\nStep N must be finished before step G can begin.\nStep M must be finished before step D can begin.\nStep F must be finished before step X can begin.\nStep S must be finished before step D can begin.\nStep Q must be finished before step F can begin.\nStep L must be finished before step R can begin.\nStep J must be finished before step F can begin.\nStep L must be finished before step T can begin.\nStep M must be finished before step H can begin.\nStep D must be finished before step F can begin.\nStep W must be finished before step B can begin.\nStep C must be finished before step A can begin.\nStep E must be finished before step I can begin.\nStep P must be finished before step Q can begin.\nStep A must be finished before step B can begin.\nStep P must be finished before step R can begin.\nStep C must be finished before step J can begin.\nStep Y must be finished before step K can begin.\nStep C must be finished before step L can begin.\nStep E must be finished before step X can begin.\nStep X must be finished before step I can begin.\nStep A must be finished before step G can begin.\nStep M must be finished before step E can begin.\nStep C must be finished before step T can begin.\nStep C must be finished before step Y can begin.\nStep K must be finished before step E can begin.\nStep H must be finished before step D can begin.\nStep P must be finished before step K can begin.\nStep D must be finished before step R can begin.\nStep J must be finished before step X can begin.\nStep H must be finished before step Z can begin.\nStep M must be finished before step R can begin.\nStep V must be finished before step U can begin.\nStep K must be finished before step B can begin.\nStep L must be finished before step Q can begin.\nStep Y must be finished before step I can begin.\nStep T must be finished before step G can begin.\nStep U must be finished before step E can begin.\nStep S must be finished before step Q can begin.\nStep P must be finished before step G can begin.\nStep P must be finished before step M can begin.\nStep N must be finished before step J can begin.\nStep P must be finished before step O can begin.\nStep U must be finished before step J can begin.\nStep C must be finished before step N can begin.\nStep W must be finished before step R can begin.\nStep B must be finished before step Z can begin.\nStep F must be finished before step Z can begin.\nStep O must be finished before step E can begin.\nStep W must be finished before step N can begin.\nStep A must be finished before step I can begin.\nStep W must be finished before step J can begin.\nStep R must be finished before step E can begin.\nStep N must be finished before step B can begin.\nStep M must be finished before step U can begin.\nStep B must be finished before step E can begin.\nStep V must be finished before step J can begin.\nStep O must be finished before step I can begin.\nStep Q must be finished before step T can begin.\nStep Q must be finished before step U can begin.\nStep L must be finished before step V can begin.\nStep S must be finished before step Z can begin.\nStep C must be finished before step P can begin.\nStep P must be finished before step A can begin.\nStep S must be finished before step G can begin.\nStep N must be finished before step H can begin.\nStep V must be finished before step H can begin.\nStep B must be finished before step I can begin."
        .split(separator: "\n")
        .map(String.init)

//var lines = [String]()
//
//while let line = readLine(strippingNewline: true) {
//    lines.append(line)
//}

print(main(lines: lines))
