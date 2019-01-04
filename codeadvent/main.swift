import Foundation

class Elf {

}

func main(target t: String, scores: (Int, Int)) -> Int {
    var index1 = 0
    var score1 = scores.0
    var index2 = 1
    var score2 = scores.1

    var scores = [score1, score2]

    let target = t.map { Int(String($0))! }

    while Array(scores.suffix(target.count)) != target {
        let total = score1 + score2
        let recipe1 = total / 10
        let recipe2 = total % 10

        if recipe1 > 0 {
            scores.append(recipe1)
        }
        scores.append(recipe2)

        index1 += 1 + score1
        index2 += 1 + score2
        index1 %= scores.count
        index2 %= scores.count
        score1 = scores[index1]
        score2 = scores[index2]

//        print(scores)
    }

    return scores.count - target.count
}

//let inputString = "/->-\\        \n|   |  /----\\\n| /-+--+-\\  |\n| | |  | v  |\n\\-+-/  \\-+--/\n  \\------/   "

//
//let input = inputString
//    .split(separator: "\n")
//    .map{Point.init(substring: $0)}

//var input = [Int]()
//var lines = [String]()
//

//while let line = readLine(strippingNewline: true) {
//    var cells = [Junction?]()
//
//    for (i, c) in line.enumerated() {
//        switch c {
//        case "<", ">", "^", "v":
//            carts.append(Cart(position: Position(i, y), character: c))
//            cells.append(nil)
//        case "/", "\\":
//            cells.append(Junction(rawValue: c))
//        case "+":
//            cells.append(.junction)
//        default:
//            cells.append(nil)
//        }
//    }
//    print(line)
//    print(cells)

//    grid.append(cells)
//    y += 1
//}

//print(main(target: "51589", scores: (3, 7)))
//print(main(target: "01245", scores: (3, 7)))
//print(main(target: "92510", scores: (3, 7)))
//print(main(target: "59414", scores: (3, 7)))
print(main(target: "327901", scores: (3, 7)))
