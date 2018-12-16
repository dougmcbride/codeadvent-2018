import Foundation

struct Input {
    let intValue: Int

    init(_ s: String) {
        let negative = s.starts(with: "-")
        let multiplier = negative ? -1 : 1
        intValue = Int(s.dropFirst(1))! * multiplier
    }
}

var inputs = [Input]()
var seen = Set<Int>()
var current = 0
var result: Int?

while let inString = readLine(strippingNewline: true) {
    inputs.append(Input(inString))
}

while result == nil {
    for input in inputs {
        seen.insert(current)
        print(seen)

        current += input.intValue

        if seen.contains(current) {
            result = current
            break
        }
    }
}

print("answer: \(result!)")
        
