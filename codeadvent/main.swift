import Foundation

struct Claim {
    let id, x, y, w, h: Int

    init(claimString: String) {
        let parts = claimString
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .filter { !$0.isEmpty }
            .map { Int($0)! }

        id = parts[0]
        x = parts[1]
        y = parts[2]
        w = parts[3]
        h = parts[4]
    }
}

enum ClaimStatus {
    case unclaimed, claimed, overClaimed
}

func main(lines: [String]) {
    let size = 1000
    var grid: [[ClaimStatus]] = Array(repeating: Array(repeating: .unclaimed,
                                                       count: size),
                                      count: size)

    let claims = lines.map { Claim(claimString: $0) }

    var overClaimed = 0
    for claim in claims {
        for x in claim.x..<(claim.x + claim.w) {
            for y in claim.y..<(claim.y + claim.h) {
                let newSquare: ClaimStatus
                switch grid[x][y] {
                case .unclaimed:
                    newSquare = .claimed
                case .claimed:
                    overClaimed += 1
                    newSquare = .overClaimed
                case .overClaimed:
                    newSquare = .overClaimed
                }
                grid[x][y] = newSquare
            }
        }
    }

    print(overClaimed)
}

//var ids = [String]()
//var lines = [
//    "#1 @ 861,330: 20x10",
//    "#2 @ 491,428: 28x23",
//    "#3 @ 64,746: 20x27",
//    "#4 @ 406,769: 25x28",
//    "#5 @ 853,621: 17x26",
//    "#6 @ 311,802: 27x28",
//    "#7 @ 947,977: 14x13",
//    "#8 @ 786,5: 18x23",
//    "#9 @ 420,429: 14x24",
//    "#10 @ 138,206: 29x28",
//]

var lines = [String]()

while let claimString = readLine(strippingNewline: true) {
    lines.append(claimString)
}

main(lines: lines)
