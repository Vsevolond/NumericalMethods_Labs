import Foundation
import Accelerate

extension Float {
    
    func pow(_ value: Int) -> Float {
        var result: Float = 1.0
        
        if value < 0 {
            for _ in 0..<abs(value) {
                result /= self
            }
            
        } else {
            for _ in 0..<value {
                result *= self
            }
        }
        
        return result
    }
}

extension Array where Element == Float {
    
    func sum() -> Float {
        reduce(into: 0) { $0 += $1 }
    }
    
    func pairs() -> [(Float, Float)] {
        (1..<count).map { (self[$0 - 1], self[$0]) }
    }
}

func slauSolution(matrixA: [[Float]], vectorB: [Float], size: Int) -> [Float] {
    var matrixT: [[Float]] = .init(repeating: .init(repeating: .zero, count: size), count: size)
    matrixT[0][0] = sqrt(matrixA[0][0])
    (1..<size).forEach { matrixT[0][$0] = matrixA[0][$0] / matrixT[0][0] }
    (1..<size).forEach { i in
        matrixT[i][i] = sqrt(matrixA[i][i] - (0..<i).map { matrixT[$0][i].pow(2) }.sum())
    }
    for j in 2..<size {
        for i in 1..<j {
            matrixT[i][j] = (matrixA[i][j] - (0..<i).map { matrixT[$0][i] * matrixT[$0][j] }.sum()) / matrixT[i][i]
        }
    }
    
    var y: [Float] = .init(repeating: .zero, count: size)
    for i in 0..<size {
        y[i] = (vectorB[i] - (0..<i).map { matrixT[$0][i] * y[$0] }.sum()) / matrixT[i][i]
    }
    
    var x: [Float] = .init(repeating: .zero, count: size)
    for i in stride(from: size - 1, to: -1, by: -1) {
        x[i] = (y[i] - (i+1..<size).map { matrixT[i][$0] * x[$0] }.sum()) / matrixT[i][i]
    }
    
    return x
}

let xArray: [Float] = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
let yArray: [Float] = [1.32, 1.81, 2.58, 2.88, 3.88, 4.29, 4.58, 5.08, 4.14]

let n: Int = xArray.count
let m: Int = 4

struct Polynom {
    
    private let factors: [Float]
    
    init(factors: [Float]) {
        self.factors = factors
    }
    
    func value(by x: Float) -> Float {
        return factors.enumerated().map { degree, factor in
            factor * x.pow(degree)
        }.sum()
    }
}

var matrixA: [[Float]] = Array(repeating: Array(repeating: .zero, count: m), count: m)
var vectorB: [Float] = Array(repeating: .zero, count: m)

for i in 0..<m {
    
    vectorB[i] = xArray.enumerated().map { j, elem in
        yArray[j] * elem.pow(i + 1)
    }.sum()
    
    for j in 0..<m {
        matrixA[i][j] = xArray.map { $0.pow(i + j + 1) }.sum()
    }
}

let lamda = slauSolution(matrixA: matrixA, vectorB: vectorB, size: m)

let function = Polynom(factors: lamda)
let variance = sqrt(xArray.enumerated().map { index, x in
    (function.value(by: x) - yArray[index]).pow(2)
}.sum())

let inaccuracy = variance / sqrt(Float(n))
let error = inaccuracy / sqrt(yArray.map { $0.pow(2) }.sum())
let middleValues = xArray.pairs().map { function.value(by: ($0 + $1) / 2) }

print(matrixA, vectorB)
print(lamda)
print(inaccuracy, error)
print(middleValues)
