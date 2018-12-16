import Foundation

var ids = [String]()
//var ids = ["adgwjcmbrkedihqtutfylyzpnx",
//           "asgwjzmbrkeeihqputfylvzpnx",
//           "csgwjzmbrkeeihqputfylvzpnx",
//           "asgwjcmbrkwdihqoutfylvzpwc",
//]

var result: String?

while let idString = readLine(strippingNewline: true) {
    ids.append(idString)
}

outerLoop: for id1 in ids {
    innerLoop: for id2 in ids {
        if id1 == id2 {
            continue
        }
        
        var indexOfDifference: String.Index?

        for index in id1.indices {
            if id1[index] != id2[index] {
                if indexOfDifference == nil {
                    indexOfDifference = index
                } else {
                    continue innerLoop
                }
            }
        }

        result = String(id1[..<indexOfDifference!]) + String(id1[id1.index(after: indexOfDifference!)...])
        break outerLoop
    }
}

print(result!)
        
