import Foundation

extension Array {
    func marble(at index: Int) -> Element {
        return self[trueIndex(of: index)]
    }

    mutating func placeMarble(marble: Element, at index: Int) -> Int {
        let realIndex = trueIndex(of: index)
        self.insert(marble, at: realIndex)
        return realIndex
    }

    mutating func removeMarble(at index: Int) -> Element {
        return self.remove(at: trueIndex(of: index))
    }

    private func trueIndex(of index: Int) -> Int {
        return (index < 0 ? count - index : index) % count
    }
}

typealias Marble = Int
typealias Score = Int

func tostring(circle: [Marble], currentIndex: Int) -> String {
    var c = 0
    return circle.reduce(into: "") { result, marble in
        result += String(format: (c == currentIndex) ?
            "(%02i)" : " %02i ", marble)
        c += 1
    }
}

func main(playerCount: Int, lastMarble: Marble) -> Score {
    var scores = Array<Score>(repeating: 0, count: playerCount)
    var circle = [0]
    var currentIndex = 0
    var currentPlayer = 0

//    let percent: Int = lastMarble / 100
    for marble in 1...lastMarble {
//        if marble % percent == 0 {
//            print(marble / percent)
//        }
        if marble % 23 == 0 {
//            print("score \(scores[currentPlayer]) -> ", terminator: "")
            scores[currentPlayer] += marble
            currentIndex -= 7
            let marble2: Int = circle.removeMarble(at: currentIndex)
            scores[currentPlayer] += marble2
            print("\(marble) and \(marble2)")
//            print(scores[currentPlayer])
        } else {
            let newIndex = currentIndex + 2
            currentIndex = circle.placeMarble(marble: marble, at: newIndex)
        }

        currentPlayer += 1
        currentPlayer %= playerCount
        currentIndex %= circle.count
//        print(tostring(circle: circle, currentIndex: currentIndex))
    }

    return scores.max()!
}

//let inputString = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

//let input = inputString
//    .split(separator: " ")
//    .map { Int($0)! }

//var input = [Int]()
//var lines = [String]()
//
//while let line = readLine(strippingNewline: true) {
//    input.append(contentsOf: line.split(separator: " ").map { Int($0)! })
//}

//print(main(playerCount: 9, lastMarble: 96))
//print(main(playerCount: 10, lastMarble: 1618))
//print(main(playerCount: 13, lastMarble: 7999))
//print(main(playerCount: 17, lastMarble: 1104))
//print(main(playerCount: 21, lastMarble: 6111))
//print(main(playerCount: 30, lastMarble: 5807))
//print()
print(main(playerCount: 418, lastMarble: 71339))
//print(main(playerCount: 418, lastMarble: 7133900))

