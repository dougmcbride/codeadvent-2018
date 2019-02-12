var frequencyChanges = [Int]()

while let frequencyChangeString = readLine(strippingNewline: true) {
    frequencyChanges.append(Int(frequencyChangeString)!)
}

var frequenciesSeen = Set<Int>()
var currentFrequency = 0

for change in frequencyChanges {
    if frequenciesSeen.contains(currentFrequency) {
        break
    }
    
    frequenciesSeen.insert(currentFrequency)
    currentFrequency += change
}

print("answer: \(currentFrequency)")
        
