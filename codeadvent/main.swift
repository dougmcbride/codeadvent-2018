import Foundation

struct Point: CustomDebugStringConvertible {
    var debugDescription: String {
        return "(\(x),\(y))"
    }
    let x, y: Int
    func distance(to point: Point) -> Int {
        return abs(point.x - x) + abs(point.y - y)
    }
}

extension Int {
    var marker: String {
        return String(Unicode.Scalar(65 + self)!)
    }
}

extension Sequence {
    func allSatisfy(_ block: (Element) -> Bool) -> Bool {
        return self.reduce(into: true) { (result, element) in result = result && block(element) }
    }
}

func main(points xys: [[Int]]) -> Int {
    let points = xys.map { Point(x: $0.first!, y: $0.last!) }

    let minX = points.map { $0.x }.min()!
    let minY = points.map { $0.y }.min()!
    let maxX = points.map { $0.x }.max()!
    let maxY = points.map { $0.y }.max()!

//    var closestPointCounts = [Int: Int]()
//    var illegalPointIndexes = Set<Int>()
    var count = 0

    for y in minY...maxY {
        xLoop: for x in minX...maxX {
            let currentPoint: Point = Point(x: x, y: y)

            let valid = points.reduce(into: 0, { (result, point) in
                result += currentPoint.distance(to: point)
            }) < 10000

            print(valid ? "#" : ".", terminator: "")
            count += valid ? 1 : 0
        }

        print()
    }

    print(count)

//    return closestPointCounts.keys.filter { !illegalPointIndexes.contains($0) }.map { closestPointCounts[$0]! }.max()!
    return count
}

//let points = [
//    [1, 1],
//    [1, 6],
//    [8, 3],
//    [3, 4],
//    [5, 5],
//    [8, 9],
//]

let points = [
    [77, 279],
    [216, 187],
    [72, 301],
    [183, 82],
    [57, 170],
    [46, 335],
    [55, 89],
    [71, 114],
    [313, 358],
    [82, 88],
    [78, 136],
    [339, 314],
    [156, 281],
    [260, 288],
    [125, 249],
    [150, 130],
    [210, 271],
    [190, 258],
    [73, 287],
    [187, 332],
    [283, 353],
    [66, 158],
    [108, 97],
    [237, 278],
    [243, 160],
    [61, 52],
    [353, 107],
    [260, 184],
    [234, 321],
    [181, 270],
    [104, 84],
    [290, 109],
    [193, 342],
    [43, 294],
    [134, 211],
    [50, 129],
    [92, 112],
    [309, 130],
    [291, 170],
    [89, 204],
    [186, 177],
    [286, 302],
    [188, 145],
    [40, 52],
    [254, 292],
    [270, 287],
    [238, 216],
    [299, 184],
    [141, 264],
    [117, 129],
]

//var lines = [
//    "[1518-11-01 00:00] Guard #10 begins shift",
//]
//
//var lines = [String]()
//
//while let claimString = readLine(strippingNewline: true) {
//    lines.append(claimString)
//}

print(main(points: points))
