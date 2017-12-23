import Foundation

let input = try! String(contentsOfFile: "day23-input.txt").trimmingCharacters(in: .whitespacesAndNewlines)
let lines = input.components(separatedBy: .newlines)

class Program {
    
    var registers = [String: Int]()
    var i = 0

    var mulCount = 0
    
    var instructions: [String]
    
    init (instructions: [String]) {
        self.instructions = instructions
    }

    func run() {
        while i < instructions.count {
            let parts = instructions[i].components(separatedBy: " ")
            let x = parts[1]
            
            let y = parts.count > 2
                ? Int(parts[2]) ?? Int(registers[parts[2]]!)
                : -1
            
            switch parts[0] {
            case "set":
                registers[x] = y
                i += 1
            case "sub":
                registers[x, default: 0] -= y
                i += 1
            case "mul":
                mulCount += 1
                registers[x, default: 0] *= y
                i += 1
            case "jnz":
                let check = Int(x) ?? registers[x, default:0]
                if check != 0 {
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
    }
}

let partOne = Program(instructions: lines)
partOne.run()
print ("Part one: \(partOne.mulCount)")

