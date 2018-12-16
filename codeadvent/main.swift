import Foundation

var totalTwos = 0
var totalThrees = 0

while let idString = readLine(strippingNewline: true) {
    var hasTwo = false
    var hasThree = false
    
    let countedLetterSet = NSCountedSet(array: Array(idString))

    nextSet: for letter in countedLetterSet.objectEnumerator() {
        switch countedLetterSet.count(for: letter) {
        case 2: hasTwo = true
        case 3: hasThree = true
        default: break
        }
        
        if hasTwo && hasThree {
            break
        }
    }
    
    totalTwos += hasTwo ? 1 : 0
    totalThrees += hasThree ? 1 : 0
}

print("2's: \(totalTwos)")
print("3's: \(totalThrees)")
print("answer: \(totalTwos * totalThrees)")
        
