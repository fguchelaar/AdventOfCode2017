import Foundation

let input = 347991

func quotient(for position: Int) -> Int {
    let squared = sqrt(Double(position))
    let ceiled = ceil(squared)
    let normalized = ceiled.truncatingRemainder(dividingBy: 2) == 0 ? ceiled + 1 : ceiled
    return Int(normalized)
}

func ring(for quotient: Int) -> Int {
    return quotient / 2
}

func ring(forPosition position: Int) -> Int {
    return ring(for: quotient(for: position))
}

func centers(for quotient: Int) -> [Int] {
    let r = ring(for: quotient)
    let q = Int(pow(Double(quotient), 2))
    return [
        q - r,
        q - r - (quotient-1),
        q - r - (quotient-1) * 2,
        q - r - (quotient-1) * 3,
    ]
}

func closestCenter(centers: [Int], position: Int) -> Int {
    let sorted = centers.sorted { abs($0-position) < abs($1-position) }
    return sorted.first!
}

func distance(for position: Int) -> Int {
    let q = quotient(for: position)
    let r = ring(for: q)
    let c = closestCenter(centers: centers(for: q), position: position)
    
    return abs(position - c) + r
}

print (distance(for: input))

func point(for position: Int) -> (x: Int, y: Int) {
    
    if position == 1 { return (0,0) }
    
    let q = quotient(for: position)
    let r = ring(forPosition: position)
    
    // corners
    if (position == Int(pow(Double(q), 2))) { return (r, -r)}
    if (position == Int(pow(Double(q), 2)) - (q-1)) { return (-r, -r)}
    if (position == Int(pow(Double(q), 2)) - ((q-1)*2)) { return (-r, r)}
    if (position == Int(pow(Double(q), 2)) - ((q-1)*3)) { return (r, r)}
    
    let c = centers(for: q)
    let cl = closestCenter(centers: c, position: position)
    let diff = position - cl
    
    let p1 = Int(pow(Double(q), 2))
    let p2 = Int(pow(Double(q-2), 2))
    
    let distance = abs(position - p2)
    let range = p1 - p2
    let quarter = range / 4
    
    var side = -1
    if distance < quarter {
        side = 1
    }
    else if distance < quarter * 2 {
        side = 2
    }
    else if distance < quarter * 3 {
        side = 3
    }
    else if distance < quarter * 4 {
        side = 4
    }
    
    switch side {
    case 1:
        return (r,diff)
    case 2:
        return (-diff,r)
    case 3:
        return (-r,-diff)
    case 4:
        return (diff,-r)
    default:
        return (-1,-1)
    }
}

func position(for point: (x: Int, y: Int)) -> Int {
    if point.x == 0 && point.y == 0 { return 1 }
    let r = max(abs(point.x), abs(point.y))
    let q = r*2 + 1
    
    // corners
    if point.x == r && point.y == -r { return q*q }
    if point.x == -r && point.y == -r { return q*q - r*2 }
    if point.x == -r && point.y == r { return q*q  - r*4 }
    if point.x == r && point.y == r { return q*q  - r*6 }
    
    if point.x == r {
        let middle = q*q - ((q-1)*3+r)
        return middle + point.y
    }
    if point.y == r {
        let middle = q*q - ((q-1)*2+r)
        return middle - point.x
    }
    if point.x == -r {
        let middle = q*q - (q-1+r)
        return middle - point.y
    }
    if point.y == -r {
        let middle = q*q - r
        return middle + point.x
    }
    return -1
}

var cache = [Int: Int]()
func value(for pos: Int) -> Int {
    if pos < 1 { return 0 }
    if pos == 1 { return 1 }
    
    if let s = cache[pos] {
        return s
    }
    
    let p = point(for: pos)
    let neigbours = [
        (p.x + 1, p.y),
        (p.x + 1, p.y + 1),
        (p.x, p.y + 1),
        (p.x - 1, p.y + 1),
        (p.x - 1, p.y),
        (p.x - 1, p.y - 1),
        (p.x, p.y - 1),
        (p.x + 1, p.y - 1)
        ].filter {  position(for: $0) < pos  }
    
    
    let sortedNeighbours = neigbours.map { position(for: $0) }.sorted(by: >)
    let sum = sortedNeighbours.reduce(0) {$0 + value(for: $1)}
    cache[pos] = sum
    return sum
}

var current = 0
var idx = 0
while current <= input {
    idx += 1
    current = value(for: idx)
}
print (current)

