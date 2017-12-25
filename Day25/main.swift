//
//  Merry christmas!
//

import Foundation

enum State {
    case A
    case B
    case C
    case D
    case E
    case F
}

let steps = 12134527
var cursor = 0
var state = State.A

var machine = [Int: Int]()

for _ in 0..<steps {
    
    switch state {
        
    case .A:
        if machine[cursor, default: 0] == 0 {
            machine[cursor] = 1
            cursor += 1
            state = .B
        }
        else {
            machine[cursor] = 0
            cursor -= 1
            state = .C
        }
    case .B:
        if machine[cursor, default: 0] == 0 {
            machine[cursor] = 1
            cursor -= 1
            state = .A
        }
        else {
            machine[cursor] = 1
            cursor += 1
            state = .C
        }
    case .C:
        if machine[cursor, default: 0] == 0 {
            machine[cursor] = 1
            cursor += 1
            state = .A
        }
        else {
            machine[cursor] = 0
            cursor -= 1
            state = .D
        }
    case .D:
        if machine[cursor, default: 0] == 0 {
            machine[cursor] = 1
            cursor -= 1
            state = .E
        }
        else {
            machine[cursor] = 1
            cursor -= 1
            state = .C
        }
    case .E:
        if machine[cursor, default: 0] == 0 {
            machine[cursor] = 1
            cursor += 1
            state = .F
        }
        else {
            machine[cursor] = 1
            cursor += 1
            state = .A
        }
    case .F:
        if machine[cursor, default: 0] == 0 {
            machine[cursor] = 1
            cursor += 1
            state = .A
        }
        else {
            machine[cursor] = 1
            cursor += 1
            state = .E
        }
    }
}

let values = machine.values
print (values.reduce(0, +))
