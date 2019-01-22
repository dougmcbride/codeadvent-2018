import Foundation

enum OpCode: Int, CaseIterable {
// (add register) stores into register C the result of adding register A and register B.
    case addr

// (add immediate) stores into register C the result of adding register A and value B.
    case addi

// (multiply register) stores into register C the result of multiplying register A and register B.
    case mulr
    case muli

// (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
    case banr
    case bani

// (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
    case borr
    case bori

// (set register) copies the contents of register A into register C. (Input B is ignored.)
    case setr
    case seti

// (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
    case gtir
    case gtri

// (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
    case gtrr

// (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
    case eqir
    case eqri

// (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
    case eqrr

    init(_ int: Int) {
        self = OpCode(rawValue: int)!
    }
}

enum Register: Int {
    case A, B, C, D

    init(_ int: Int) {
        self = Register(rawValue: int)!
    }
}

struct Instruction {
    private let values: [Int]

    var opCode: OpCode {
        return OpCode(values.first!)
    }

    var A: Int {
        return values[1]
    }

    var B: Int {
        return values[2]
    }

    var C: Int {
        return values[3]
    }

    init(string: Substring) {
        self.values = string
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .compactMap { Int($0) }
    }

    private init(_ values: [Int]) {
        self.values = values
    }

    func with(opCode: OpCode) -> Instruction {
        return Instruction([opCode.rawValue, values[1], values[2], values[3]])
    }
}

extension Instruction: CustomStringConvertible {
    public var description: String {
        return "\(OpCode(rawValue: values[0])!) \(values[1...3].map { String($0) }.joined(separator: " "))"
    }
}

struct State: Equatable {
    var reg = [Int](repeating: 0, count: 4)

    init(string: Substring) {
        self.reg = string
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .compactMap { Int($0) }
    }

    mutating func execute(_ i: Instruction) {
        let valA: Int = i.A
        let valB: Int = i.B
        let regA: Int! = valA < reg.count ? reg[valA] : nil
        let regB: Int! = valB < reg.count ? reg[valB] : nil

        let regC: Int

        switch i.opCode {
        case .addr: regC = regA + regB
        case .addi: regC = regA + valB
        case .mulr: regC = regA * regB
        case .muli: regC = regA * valB
        case .banr: regC = regA & regB
        case .bani: regC = regA & valB
        case .borr: regC = regA | regB
        case .bori: regC = regA | valB
        case .setr: regC = regA
        case .seti: regC = valA
        case .gtir: regC = valA > regB ? 1 : 0
        case .gtri: regC = regA > valB ? 1 : 0
        case .gtrr: regC = regA > regB ? 1 : 0
        case .eqir: regC = valA == regB ? 1 : 0
        case .eqri: regC = regA == valB ? 1 : 0
        case .eqrr: regC = regA == regB ? 1 : 0
        }

        reg[i.C] = regC
    }
}

/*
Before: [2, 0, 0, 1]
15 3 1 3
After:  [2, 0, 0, 1]

Before: [3, 2, 3, 3]
4 3 3 0
After:  [3, 2, 3, 3]

*/

struct StringReader {
    private let string: String
    private var index: String.Index

    init(_ string: String) {
        self.string = string
        self.index = string.startIndex
    }

    mutating func nextLine() -> Substring? {
        guard let lineEndIndex = string
            .range(of: "\n", range: index..<string.endIndex)?
            .lowerBound else { return nil }

        let lineString = string[index..<lineEndIndex]

        index = string.index(index, offsetBy: lineString.count + 1, limitedBy: string.endIndex)!
        return lineString
    }
}

func main(inputPath: String) -> Int {
    var reader = StringReader(try! String(contentsOfFile: inputPath))
    var count = 0

    repeat {
        guard let nextLine = reader.nextLine() else {
            return count
        }

        let startState = State(string: nextLine)
        let instruction = Instruction(string: reader.nextLine()!)
        let endState = State(string: reader.nextLine()!)

        // Skip line
        let _ = reader.nextLine()

        var matchCount = 0
        print("start state: \(startState)")
        for opCode in OpCode.allCases {
            var state = startState
            let instruction2: Instruction = instruction.with(opCode: opCode)
            state.execute(instruction2)
            if state == endState {
                print(instruction2)
                print("end state: \(state)")
                matchCount += 1
            }
        }

        if matchCount > 2 {
            count += 1
        }
    } while true
}

// Don't buffer print() output
setbuf(__stdoutp, nil)

guard CommandLine.arguments.count == 2 else {
    print("Usage: codeadvent <input-file>")
    exit(1)
}

print(main(inputPath: CommandLine.arguments.last!))
