import Foundation

let input = try! String(contentsOfFile: "day18-input.txt").trimmingCharacters(in: .whitespacesAndNewlines)
let lines = input.components(separatedBy: .newlines)

enum State {
    case normal
    case waiting
    case finished
}

class Program {
    
    var registers = [String: Int]()
    var state: State = .normal
    var i = 0
    
    var outbox = [Int]()
    var inbox = [Int]()
    var sendCount = 0
    
    var instructions: [String]
    
    init (instructions: [String]) {
        self.instructions = instructions
    }

    init (instructions: [String], p: Int) {
        self.instructions = instructions
        registers["p"] = p
    }

    func run(partOne: Bool) {
        state = .normal

        while i < instructions.count {
            let parts = instructions[i].components(separatedBy: " ")
            let x = parts[1]
            
            let y = parts.count > 2
                ? Int(parts[2]) ?? Int(registers[parts[2]]!)
                : -1
            
            switch parts[0] {
            case "snd":
                outbox.append(registers[x] ?? Int(x)!)
                sendCount += 1
                i += 1
            case "set":
                registers[x] = y
                i += 1
            case "add":
                registers[x] = (registers[x] ?? 0) + y
                i += 1
            case "mul":
                registers[x] = (registers[x] ?? 0) * y
                i += 1
            case "mod":
                registers[x] = (registers[x] ?? 0) % y
                i += 1
            case "rcv":
                let check = registers[x] ?? 0
                if partOne && check != 0 {
                    state = .finished
                    return
                }
                else if !inbox.isEmpty {
                    registers[x] = inbox.removeFirst()
                    i += 1
                }
                else {
                    state = .waiting
                    return
                }
            case "jgz":
                let check = registers[x] ?? Int(x)!
                if check > 0 {
                    i += y
                }
                else {
                    i += 1
                }
            default:
                // noop
                print ("invalid instruction: \(instructions[i])")
            }
        }
        state = .finished
    }
}

// MARK: run the program and get the last element of the outbox
let partOne = Program(instructions: lines)
partOne.run(partOne: true)
print ("Part one: \(partOne.outbox.last!)")

// MARK: create two programs, toggle until both are .finished and/or .waiting
let p0 = Program(instructions: lines, p: 0)
let p1 = Program(instructions: lines, p: 1)

var active, dorment: Program
active = p0
while (true) {
    if active === p1 {
        active = p0
        dorment = p1
    }
    else {
        active = p1
        dorment = p0
    }
    active.run(partOne: false)

    dorment.inbox.append(contentsOf: active.outbox)
    active.outbox.removeAll()

    if active.state == .finished && dorment.state == .finished {
        break
    }
    else if active.state == .waiting && dorment.state == .waiting
        && active.inbox.isEmpty && dorment.inbox.isEmpty {
        break
    }
}

print ("Part two: \(p1.sendCount)")
