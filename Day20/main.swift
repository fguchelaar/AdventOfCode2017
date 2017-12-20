import Foundation

let input = try! String(contentsOfFile: "day20-input.txt").trimmingCharacters(in: .whitespacesAndNewlines)

struct Vector: Equatable, Hashable {
    var x: Int
    var y: Int
    var z: Int
    
    var distance: Int {
        return abs(x) + abs(y) + abs(z)
    }

    static func ==(lhs: Vector, rhs: Vector) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }

    var hashValue: Int {
        return "x\(x),y\(y),z\(z)".hashValue
    }
}

struct Particle {
    
    init(string: String) {
        let components = string
            .components(separatedBy: CharacterSet(charactersIn: "pva=<> "))
            .filter { !$0.isEmpty }
            .joined()
            .components(separatedBy: ",")
            .map { Int($0)! }
        position = Vector(x: components[0], y: components[1], z: components[2])
        velocity = Vector(x: components[3], y: components[4], z: components[5])
        acceleration = Vector(x: components[6], y: components[7], z: components[8])
    }
    
    var position: Vector
    var velocity: Vector
    var acceleration: Vector
    
    func displacement(velocity v: Int, acceleration a: Int, time t: Int) -> Int {
        let vt = v + (a * t)
        return (v + vt + a) * (t) / 2
    }
    
    func positionAfter(t: Int) -> Vector {
        return Vector(x: position.x + displacement(velocity: velocity.x, acceleration: acceleration.x, time: t),
            y: position.y + displacement(velocity: velocity.y, acceleration: acceleration.y, time: t),
            z: position.z + displacement(velocity: velocity.z, acceleration: acceleration.z, time: t))
    }
}

var particles = input
    .components(separatedBy: .newlines)
    .map { Particle(string: $0) }

// MARK: Part one, calculate positions after 100000 steps, seems far enough for "in the long term"
let t = 100000
let closestParticle = particles
    .enumerated()
    .map { ($0.offset, $0.element.positionAfter(t: t)) }
    .sorted { $0.1.distance < $1.1.distance }
    .first!

print("Part one: \(closestParticle.0) (\(closestParticle.1.distance))")

// MARK: Part two, simulate for _n_ times, count leftovers afterwards
let n = 100
for i in 0..<n {
    
    let positions = particles
        .enumerated()
        .map { ($0.offset, $0.element.positionAfter(t: i)) }
    
    let counts = positions.reduce(into: [:], { (dict, tuple) in
        dict[tuple.1, default: 0] += 1
    })
    
    let toRemoveIndexes = positions
        .filter { counts[$0.1]! > 1 }
        .map { $0.0 }
    
    particles = particles
        .enumerated()
        .filter { !toRemoveIndexes.contains($0.offset) }
        .map { $0.element }
}
print("Part two: \(particles.count)")
