var frequencyChanges = [Int]()

while let frequencyChangeString = readLine(strippingNewline: true) {
    frequencyChanges.append(Int(frequencyChangeString)!)
}

var frequenciesSeen = Set<Int>()
var currentFrequency = 0

for frequencyIndex in 0..<Int.max {
    if frequenciesSeen.contains(currentFrequency) {
        break
    }

    frequenciesSeen.insert(currentFrequency)
    currentFrequency += frequencyChanges[frequencyIndex % frequencyChanges.count]
}

print("answer: \(currentFrequency)")
        
