import Foundation

struct Cell {
    let position: (Int, Int)
    let serialNumber: Int

    var power: Int {
        // Find the fuel cell's rack ID, which is its X coordinate plus 10.
        let rackId = position.0 + 10
        //Begin with a power level of the rack ID times the Y coordinate.
        var p = rackId * position.1
        //Increase the power level by the value of the grid serial number (your puzzle input).
        p += serialNumber
        //Set the power level to itself multiplied by the rack ID.
        p *= rackId
        //Keep only the hundreds digit of the power level (so 12345 becomes 3; numbers with no hundreds digit become 0).
        p = p / 100 % 10
        //Subtract 5 from the power level.
        p -= 5
        return p
    }
}

func main(serialNumber: Int) -> (Int, Int, Int) {
    var startingPosition: (Int, Int)?
    var maxSize: Int?
    var maxPower = Int.min

    for size in 1...300 {
        print(size)
        for x in 0...300 - size {
            for y in 0...300 - size {
                var totalPower = 0

                for dx in 0..<size {
                    for dy in 0..<size {
                        totalPower += Cell(position: (x + dx, y + dy), serialNumber: serialNumber).power
                    }
                }

                if totalPower > maxPower {
                    maxPower = totalPower
                    startingPosition = (x, y)
                    maxSize = size
                }
            }
        }
    }

    return (startingPosition!.0, startingPosition!.1, maxSize!)
}

//let inputString = "position=< 9,  1> velocity=< 0,  2>\nposition=< 7,  0> velocity=<-1,  0>\nposition=< 3, -2> velocity=<-1,  1>\nposition=< 6, 10> velocity=<-2, -1>\nposition=< 2, -4> velocity=< 2,  2>\nposition=<-6, 10> velocity=< 2, -2>\nposition=< 1,  8> velocity=< 1, -1>\nposition=< 1,  7> velocity=< 1,  0>\nposition=<-3, 11> velocity=< 1, -2>\nposition=< 7,  6> velocity=<-1, -1>\nposition=<-2,  3> velocity=< 1,  0>\nposition=<-4,  3> velocity=< 2,  0>\nposition=<10, -3> velocity=<-1,  1>\nposition=< 5, 11> velocity=< 1, -2>\nposition=< 4,  7> velocity=< 0, -1>\nposition=< 8, -2> velocity=< 0,  1>\nposition=<15,  0> velocity=<-2,  0>\nposition=< 1,  6> velocity=< 1,  0>\nposition=< 8,  9> velocity=< 0, -1>\nposition=< 3,  3> velocity=<-1,  1>\nposition=< 0,  5> velocity=< 0, -1>\nposition=<-2,  2> velocity=< 2,  0>\nposition=< 5, -2> velocity=< 1,  2>\nposition=< 1,  4> velocity=< 2,  1>\nposition=<-2,  7> velocity=< 2, -2>\nposition=< 3,  6> velocity=<-1, -1>\nposition=< 5,  0> velocity=< 1,  0>\nposition=<-6,  0> velocity=< 2,  0>\nposition=< 5,  9> velocity=< 1, -2>\nposition=<14,  7> velocity=<-2,  0>\nposition=<-3,  6> velocity=< 2, -1>\n"
//
//let input = inputString
//    .split(separator: "\n")
//    .map{Point.init(substring: $0)}

//var input = [Int]()
//var lines = [String]()
//

//var lights = [Point]()
//while let line = readLine(strippingNewline: true) {
//    lights.append(Point(string: line))
//}

//print(main(serialNumber: 42))
print(main(serialNumber: 1309))

