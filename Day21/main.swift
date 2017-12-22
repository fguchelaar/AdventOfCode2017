import Foundation

let input = try! String(contentsOfFile: "day21-input.txt").trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
//let input = """
//../.# => ##./#../...
//.#./..#/### => #..#/..../..../#..#
//""".components(separatedBy: .newlines)

struct Pattern: CustomStringConvertible, Hashable, Equatable {
    
    var grid: [[Character]]
    
    init(withGrid grid: [[Character]]) {
        self.grid = grid
    }
    
    init(fromString string: String) {
        grid = string
            .components(separatedBy: "/")
            .map { $0.map { $0 } }
    }
    
    init(fromSlices slices: [[Pattern]]) {
        let sliceSize = slices[0][0].size
        
        grid = Array(repeating: Array(repeating: Character("."), count: sliceSize * slices.count), count: sliceSize * slices.count)
        
        for row in 0..<slices.count {
            for col in 0..<slices[row].count {
                let slice = slices[row][col]
                
                for srow in 0..<sliceSize {
                    for scol in 0..<sliceSize {
                        grid[row * sliceSize + srow][col * sliceSize + scol] = slice.grid[srow][scol]
                    }
                }
            }
        }
    }
    
    var size: Int {
        return grid.count
    }
    
    var numberOfLightsOn: Int {
        return grid
            .flatMap { $0 }
            .filter{ $0 == "#" }
            .count
    }
    
    func rotated(times n: Int) -> Pattern {
        var toRotate = grid
        for _ in 0..<n {
            var newGrid = Array(repeating: Array(repeating: Character("."), count: size), count: size)
            for row in 0..<size {
                for col in 0..<size {
                    newGrid[row][col] = toRotate[size-col-1][row]
                }
            }
            toRotate = newGrid
        }
        return Pattern(withGrid: toRotate)
    }
    
    func flipped() -> Pattern {
        return Pattern(withGrid: grid.map { $0.reversed() })
    }
    
    func sliced(bySize sliceSize: Int) -> [[Pattern]] {
        var sliced = Array(repeating: Array(repeating: Pattern(fromString: "."), count: size/sliceSize), count: size/sliceSize)
        
        for srow in 0..<size/sliceSize {
            for scol in 0..<size/sliceSize {
                var newSliceGrid = Array(repeating: Array(repeating: Character("."), count: sliceSize), count: sliceSize)
                for row in srow*sliceSize..<srow*sliceSize + sliceSize {
                    for col in scol*sliceSize..<scol*sliceSize + sliceSize {
                        newSliceGrid[row % sliceSize][col % sliceSize] = grid[row][col]
                    }
                }
                sliced[srow][scol] = Pattern(withGrid: newSliceGrid)
            }
        }
        return sliced
    }
    
    var description: String {
        return grid
            .flatMap { String($0) }
            .joined(separator: "/")
    }
    
    var hashValue: Int {
        return description.hashValue
    }
    
    static func ==(lhs: Pattern, rhs: Pattern) -> Bool {
        return lhs.description == rhs.description
    }
}

var pattern = Pattern(withGrid: [
    [".", "#", "."],
    [".", ".", "#"],
    ["#", "#", "#"]
    ])

var rules: [Pattern: Pattern] = input.reduce(into: [:]) { (dict, line) in
    let parts = line.components(separatedBy: " => ")
    let rule = Pattern(fromString: parts[0])
    let enhancement = Pattern(fromString: parts[1])
    
    dict[rule] = enhancement
    dict[rule.rotated(times: 1)] = enhancement
    dict[rule.rotated(times: 2)] = enhancement
    dict[rule.rotated(times: 3)] = enhancement
    dict[rule.flipped()] = enhancement
    dict[rule.flipped().rotated(times: 1)] = enhancement
    dict[rule.flipped().rotated(times: 2)] = enhancement
    dict[rule.flipped().rotated(times: 3)] = enhancement
}

var p = Pattern(fromString: ".#./..#/###")

let numberOfIterations = 18

measure {
    for i in 0..<numberOfIterations {
        let size = p.size % 2 == 0 ? 2 : 3
        let slices = p.sliced(bySize: size)
        let enhanced = slices.map{ $0.map{ rules[$0] ?? $0 } }
        p = Pattern(fromSlices: enhanced)
        
        if i == 4 {
            print ("Part one: \(p.numberOfLightsOn)")
        }
    }
}
print ("Part two: \(p.numberOfLightsOn)")

