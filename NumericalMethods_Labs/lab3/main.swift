import Foundation

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
    
    var minAll: (element: Float, indexes: [Int]) {
        var min: (element: Float, indexes: [Int]) = (self[0], [0])
        for i in 1..<count {
            
            if self[i] < min.element {
                min = (self[i], [i])
                
            } else if self[i] == min.element {
                min.indexes.append(i)
            }
        }
        
        return min
    }
}

func slauSolution(matrixA: [[Float]], vectorB: [Float], size: Int) -> [Float] {
    var matrixT: [[Float]] = .init(repeating: .init(repeating: .zero, count: size), count: size)
    
    for i in 0..<size {
        for j in 0...i {
            
            if i == j {
                let sum = (0..<j).map { matrixT[j][$0].pow(2) }.sum()
                matrixT[j][j] = sqrtf(matrixA[j][j] - sum)
                
            } else {
                let sum = (0..<j).map { matrixT[i][$0] * matrixT[j][$0] }.sum()
                matrixT[i][j] = (matrixA[i][j] - sum) / matrixT[j][j]
            }
        }
    }
    
    var y: [Float] = .init(repeating: .zero, count: size)
    for i in 0..<size {
        let sum = (0..<i).map { matrixT[i][$0] * y[$0] }.sum()
        y[i] = (vectorB[i] - sum) / matrixT[i][i]
    }
    
    var x: [Float] = .init(repeating: .zero, count: size)
    for i in stride(from: size - 1, through: 0, by: -1) {
        let sum = (i+1..<size).map { matrixT[$0][i] * x[$0] }.sum()
        x[i] = (y[i] - sum) / matrixT[i][i]
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

let polynom = Polynom(factors: lamda)
var variance = sqrtf(xArray.enumerated().map { index, x in
    (polynom.value(by: x) - yArray[index]).pow(2)
}.sum())

let inaccuracy = variance / sqrtf(Float(n))
let error = inaccuracy / sqrtf(yArray.map { $0.pow(2) }.sum())
var middleValues = xArray.pairs().map { polynom.value(by: ($0 + $1) / 2) }

print("Матрица A:")
for row in matrixA {
    print(row)
}
print("Вектор B: ", vectorB)
print("Кэффициенты многочлена: ", lamda)
print("Абсолютная погрешность: ", inaccuracy)
print("Относительная ошибка: ", error)
print("Значения в средних точках: ", middleValues)

let middleX: (arithmetic: Float, geometric: Float, harmonic: Float) = (
    (xArray[0] + xArray[n - 1]) / 2,
    sqrtf(xArray[0] * xArray[n - 1]),
    2 / (1 / xArray[0] + 1 / xArray[n - 1])
)
let middleY: (arithmetic: Float, geometric: Float, harmonic: Float) = (
    (yArray[0] + yArray[n - 1]) / 2,
    sqrtf(yArray[0] * yArray[n - 1]),
    2 / (1 / yArray[0] + 1 / yArray[n - 1])
)

let middleZ: (arithmetic: Float, geometric: Float, harmonic: Float) = (
    polynom.value(by: middleX.arithmetic),
    polynom.value(by: middleX.geometric),
    polynom.value(by: middleX.harmonic)
)

let delta1 = abs(middleZ.arithmetic - middleY.arithmetic)
let delta2 = abs(middleZ.geometric - middleY.geometric)
let delta3 = abs(middleZ.arithmetic - middleY.geometric)
let delta4 = abs(middleZ.geometric - middleY.arithmetic)
let delta5 = abs(middleZ.harmonic - middleY.arithmetic)
let delta6 = abs(middleZ.arithmetic - middleY.harmonic)
let delta7 = abs(middleZ.harmonic - middleY.harmonic)
let delta8 = abs(middleZ.harmonic - middleY.geometric)
let delta9 = abs(middleZ.geometric - middleY.harmonic)

let minAll = [delta1, delta2, delta3, delta4, delta5, delta6, delta7, delta8, delta9].minAll
guard minAll.indexes.count == 1, let funcType = minAll.indexes.first else {
    fatalError("error")
}

print("Тип аппроксимирующей функции: ", "z\(funcType + 1)")

func z4(a: Float, b: Float, x: Float) -> Float {
    return a * logf(x) + b
}

let a: Float = xArray.map { logf($0).pow(2) }.sum()
let b: Float = xArray.map { logf($0) }.sum()
let c: Float = xArray.enumerated().map { index, elem in
    return logf(elem) * yArray[index]
}.sum()
let d: Float = yArray.map { $0 }.sum()

let divisor: Float = b * b - a * Float(n)
let alpha: Float = (d * b - c * Float(n)) / divisor
let betta: Float = (c * b - a * d) / divisor

print("Значения a и b: ", alpha, betta)

middleValues = xArray.pairs().map { z4(a: alpha, b: betta, x: ($0 + $1) / 2) }
print("Значения в средних точках: ", middleValues)

variance = sqrtf(xArray.enumerated().map { index, x in
    (z4(a: alpha, b: betta, x: x) - yArray[index]).pow(2)
}.sum())
print("СКУ: ", variance)
