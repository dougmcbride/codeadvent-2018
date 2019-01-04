import Foundation

class Elf {

}

func main(recipes: Int, scores: (Int, Int)) -> String {
    var index1 = 0
    var score1 = scores.0
    var index2 = 1
    var score2 = scores.1

    var scores = [score1, score2]

    while scores.count < recipes + 10 {
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

    return scores.dropFirst(recipes).prefix(10).map { String($0) }.joined()
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

//print(main(recipes: 9, scores: (3, 7)))
//print(main(recipes: 5, scores: (3, 7)))
//print(main(recipes: 18, scores: (3, 7)))
//print(main(recipes: 2018, scores: (3, 7)))
print(main(recipes: 327901, scores: (3, 7)))
