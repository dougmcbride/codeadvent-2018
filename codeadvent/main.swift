import Foundation

enum OpCode: Int, CaseIterable {
    case gtir
    case mulr
    case seti
    case gtrr
    case bori
    case borr
    case banr
    case eqri
    case bani
    case addr
    case addi
    case eqrr
    case gtri
    case eqir
    case setr
    case muli

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

    init(string: String) {
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

    init() {
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

func main(inputPath: String) -> Int {
    let input = try! String(contentsOfFile: inputPath)

    let state = input
        .components(separatedBy: .newlines)
        .reduce(into: State()) {
            print($0)
            let instruction = Instruction(string: $1)
            print(instruction)
            $0.execute(instruction)
        }

    print(state)
    return state.reg.first!
}

// Don't buffer print() output
setbuf(__stdoutp, nil)

guard CommandLine.arguments.count == 2 else {
    print("Usage: codeadvent <input-file>")
    exit(1)
}

print(main(inputPath: CommandLine.arguments.last!))
