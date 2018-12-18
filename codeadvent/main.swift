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

extension Claim: Hashable {
    static func ==(lhs: Claim, rhs: Claim) -> Bool {
        return lhs.id == rhs.id
    }
    public var hashValue: Int {
        return id
    }
}

//enum ClaimStatus {
//    case unclaimed, claimed, overClaimed
//}

func main(lines: [String]) {
    let size = 1000
    var grid: [[Set<Claim>]] = Array(repeating: Array(repeating: [], count: size),
                                     count: size)

    var claims = Set<Claim>(lines.map { Claim(claimString: $0) })

    for claim in claims {
        for xd in 0..<claim.w {
            for yd in 0..<claim.h {
                let x = claim.x + xd
                let y = claim.y + yd
                grid[x][y].insert(claim)

                if grid[x][y].count > 1 {
                    claims.subtract(grid[x][y])
                }
            }
        }
    }

    print(claims)
}

//var ids = [String]()
//var lines = [
//"#1 @ 1,3: 4x4",
//"#2 @ 3,1: 4x4",
//"#3 @ 5,5: 2x2",
//]

var lines = [String]()

while let claimString = readLine(strippingNewline: true) {
    lines.append(claimString)
}

main(lines: lines)
