var frequencyChanges = [Int]()

while let frequencyChangeString = readLine(strippingNewline: true) {
    frequencyChanges.append(Int(frequencyChangeString)!)
}

var frequenciesSeen = Set<Int>()
var currentFrequency = 0
var frequencyIndex = 0

repeat {
    frequenciesSeen.insert(currentFrequency)
    currentFrequency += frequencyChanges[frequencyIndex % frequencyChanges.count]
    frequencyIndex += 1
} while !frequenciesSeen.contains(currentFrequency) 

print("answer: \(currentFrequency)")
        
