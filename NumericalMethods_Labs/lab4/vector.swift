import Foundation

class Vector {
    
    private var array: [Float]
    var size: Int { array.count }
    
    var max: Float { array.max() ?? 0 }
    
    init(size: Int) {
        self.array = .init(repeating: 0, count: size)
    }
    
    init(array: [Float]) {
        self.array = array
    }
    
    subscript(index: Int) -> Float {
        get {
            guard index >= 0, index < size else { return 0 }
            return array[index]
        }
        set(newValue) {
            guard index >= 0, index < size else { return }
            array[index] = newValue
        }
    }
    
    static func -= (lhs: inout Vector, rhs: Vector) {
        for i in 0..<min(lhs.size, rhs.size) {
            lhs[i] -= rhs[i]
        }
    }
    
    func absolute() -> Vector {
        let newArray: [Float] = array.map { abs($0) }
        return .init(array: newArray)
    }
    
    func map(_ mapping: (Float) -> Float) -> Vector {
        let newArray: [Float] = array.map { mapping($0) }
        return .init(array: newArray)
    }
    
    func printV() { print(array) }
}
