import Foundation

let input = try! String(contentsOfFile: "day19-input.txt")

class MazeWalker {
    
    enum Direction: Int {
        case up = 0
        case right
        case down
        case left
        
        func turnLeft() -> Direction {
            return Direction(rawValue: (self.rawValue - 1 + 4) % 4)!
        }
        
        func turnRight() -> Direction {
            return Direction(rawValue: (self.rawValue + 1) % 4)!
        }
        
        var vector: (dx: Int, dy: Int) {
            switch self {
            case .up:
                return (0, -1)
            case .right:
                return (1, 0)
            case .down:
                return (0, 1)
            case .left:
                return (-1, 0)
            }
        }
    }
    
    var maze: [[Character]]
    var position: (x: Int, y: Int)
    var direction = Direction.down
    var letters = [Character]()
    var numberOfSteps = 0
    
    init(maze: [[Character]]) {
        self.maze = maze
        self.position = (x: Int(maze[0].index(of: "|")!), y: 0)
    }

    func changeDirection() {
        let options = [direction.turnLeft(),direction.turnRight()]
        
        let newDirection = options.first {
            let newPosition = (x: position.x + $0.vector.dx, y: position.y + $0.vector.dy)
            if (newPosition.x < 0 || newPosition.x > maze.count) || (newPosition.y < 0 || newPosition.y > maze[newPosition.x].count) {
                return false
            }
            else {
                return maze[newPosition.y][newPosition.x] != " "
            }
        }
        
        if newDirection != nil {
            direction = newDirection!
        }
    }
    
    func findExit() {
        outerLoop: while true {
            switch maze[position.y][position.x] {
            case " ":
                break outerLoop
            case "+":
               changeDirection()
            case "|","-":
                break
            default:
                letters.append(maze[position.y][position.x])
            }
            position.x += direction.vector.dx
            position.y += direction.vector.dy
            numberOfSteps += 1
        }
    }
}

func parseMaze(string: String) -> [[Character]] {
    return string.components(separatedBy: .newlines).map { $0.map { $0 } }
}

let walker = MazeWalker(maze: parseMaze(string: input))
walker.findExit()

print("Part one: \(String(walker.letters))")
print("Part two: \(walker.numberOfSteps)")
