import Foundation

func int(_ substring: Substring) -> Int {
    return Int(substring.trimmingCharacters(in: .whitespaces))!
}

struct Vector {
    let x, y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

struct Point {
    var position: Vector
    var velocity: Vector
    
    init(position: Vector, velocity: Vector) {
        self.position = position
        self.velocity = velocity
    }

    init(string: String) {
        let pWidth = 6
        let vWidth = 2
        let pxStart = string.index(string.startIndex, offsetBy: "position=<".count)
        let pxEnd = string.index(pxStart, offsetBy: pWidth)
        let pyStart = string.index(pxEnd, offsetBy: 2)
        let pyEnd = string.index(pyStart, offsetBy: pWidth)
        let vxStart = string.index(pyEnd, offsetBy: "> velocity=<".count)
        let vxEnd = string.index(vxStart, offsetBy: vWidth)
        let vyStart = string.index(vxEnd, offsetBy: 2)
        let vyEnd = string.index(vyStart, offsetBy: vWidth)

        position = Vector(int(string[pxStart..<pxEnd]),
                          int(string[pyStart..<pyEnd]))
        velocity = Vector(int(string[vxStart..<vxEnd]),
                          int(string[vyStart..<vyEnd]))
    }
    
    init(substring: Substring) {
        self.init(string: String(substring))
    }
    
}

class Sky {
    var lights: [Point] = []

    init(lights: [Point]) {
        self.lights = lights
    }

    var isLetters: Bool {
        return lights.reduce(into: true) { result, light in result = result && hasNeighbor(light) }
    }

    func moveLights() {
        for (index, light) in lights.enumerated() {
            lights[index] = Point(position: Vector(light.position.x + light.velocity.x,
                                                   light.position.y + light.velocity.y),
                                  velocity: light.velocity)
        }
    }
    private func hasNeighbor(_ light: Point) -> Bool {
        for dx in -1...1 {
            for dy in -1...1 {
                guard dx != 0 || dy != 0 else { continue }
                if lights.contains(where: {
                    return $0.position.x == light.position.x + dx && $0.position.y == light.position.y + dy
                }) {
                    return true
                }
            }
        }
        return false
    }
}

extension Sky: CustomStringConvertible {
    public var description: String {
        let minX = lights.map { $0.position.x }.min()!
        let maxX = lights.map { $0.position.x }.max()!
        let minY = lights.map { $0.position.y }.min()!
        let maxY = lights.map { $0.position.y }.max()!

        var string = ""
        for y in minY...maxY {
            for x in minX...maxX {
                string += lights.contains(where: { $0.position.x == x && $0.position.y == y }) ?
                    "#" : " "
            }
            string += "\n"
        }
        return string
    }
}

func main(lights: [Point]) -> String {
    let sky = Sky(lights: lights)

    while !sky.isLetters {
        sky.moveLights()
    }

    return sky.description
}

//let inputString = "position=< 9,  1> velocity=< 0,  2>\nposition=< 7,  0> velocity=<-1,  0>\nposition=< 3, -2> velocity=<-1,  1>\nposition=< 6, 10> velocity=<-2, -1>\nposition=< 2, -4> velocity=< 2,  2>\nposition=<-6, 10> velocity=< 2, -2>\nposition=< 1,  8> velocity=< 1, -1>\nposition=< 1,  7> velocity=< 1,  0>\nposition=<-3, 11> velocity=< 1, -2>\nposition=< 7,  6> velocity=<-1, -1>\nposition=<-2,  3> velocity=< 1,  0>\nposition=<-4,  3> velocity=< 2,  0>\nposition=<10, -3> velocity=<-1,  1>\nposition=< 5, 11> velocity=< 1, -2>\nposition=< 4,  7> velocity=< 0, -1>\nposition=< 8, -2> velocity=< 0,  1>\nposition=<15,  0> velocity=<-2,  0>\nposition=< 1,  6> velocity=< 1,  0>\nposition=< 8,  9> velocity=< 0, -1>\nposition=< 3,  3> velocity=<-1,  1>\nposition=< 0,  5> velocity=< 0, -1>\nposition=<-2,  2> velocity=< 2,  0>\nposition=< 5, -2> velocity=< 1,  2>\nposition=< 1,  4> velocity=< 2,  1>\nposition=<-2,  7> velocity=< 2, -2>\nposition=< 3,  6> velocity=<-1, -1>\nposition=< 5,  0> velocity=< 1,  0>\nposition=<-6,  0> velocity=< 2,  0>\nposition=< 5,  9> velocity=< 1, -2>\nposition=<14,  7> velocity=<-2,  0>\nposition=<-3,  6> velocity=< 2, -1>\n"
//
//let input = inputString
//    .split(separator: "\n")
//    .map{Point.init(substring: $0)}

//var input = [Int]()
//var lines = [String]()
//

var lights = [Point]()
while let line = readLine(strippingNewline: true) {
    lights.append(Point(string: line))
}

print(main(lights: lights))

