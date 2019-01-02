import Foundation

let generations = 20

func main(initial: String, rules: [String: String]) -> Int {
    let padding = "........................................"
    var state = padding + initial + padding
    print(state)

    for _ in 0..<generations {
        var newState = ".."
        for index in 2..<state.count - 2 {
            let start = state.index(state.startIndex, offsetBy: index - 2)
            let end = state.index(start, offsetBy: 5)
            newState += rules[String(state[start..<end])] ?? "."
        }
        newState += ".."
        print(newState)
        
        state = newState
    }

    return state.enumerated().reduce(into: 0) { total, c in 
        total += c.1 == "#" ?
             c.0 - 40 : 0
    }
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

let initial = "####....#...######.###.#...##....#.###.#.###.......###.##..##........##..#.#.#..##.##...####.#..##.#"

let rules = [
    "..#..": ".",
    "#.#.#": "#",
    "#.###": "#",
    ".##..": ".",
    "#.#..": "#",
    ".#.#.": "#",
    ".###.": "#",
    ".####": "#",
    "##...": "#",
    "#.##.": "#",
    "#..##": "#",
    "....#": ".",
    "###.#": ".",
    "#####": "#",
    ".....": ".",
    "..#.#": ".",
    ".#...": "#",
    "##.#.": ".",
    ".#.##": "#",
    "..##.": ".",
    "#...#": ".",
    "##.##": "#",
    "...#.": ".",
    "#..#.": ".",
    "..###": ".",
    ".##.#": ".",
    "#....": ".",
    ".#..#": "#",
    "####.": ".",
    "...##": "#",
    "##..#": ".",
    "###..": ".",
]

//let initial = "#..#.#..##......###...###"
//
//let rules = [
//    "...##": "#",
//    "..#..": "#",
//    ".#...": "#",
//    ".#.#.": "#",
//    ".#.##": "#",
//    ".##..": "#",
//    ".####": "#",
//    "#.#.#": "#",
//    "#.###": "#",
//    "##.#.": "#",
//    "##.##": "#",
//    "###..": "#",
//    "###.#": "#",
//    "####.": "#",
//]
/*
...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #
*/

print(main(initial: initial, rules: rules))
