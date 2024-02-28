import Foundation

func y(x: Double) -> Double {
    return x * sin(x) * sin(x)
}

let a: Double = 0
let b: Double = .pi

let n: Int = 10
let h: Double = (b - a) / Double(n)

let xArray: [Double] = (0...n).map { a + Double($0) * h }
let yArray: [Double] = (0...n).map { y(x: xArray[$0]) }
let vector: [Double] = (1...n - 1).map { i in
    let first: Double = yArray[i + 1] - 2 * yArray[i] + yArray[i - 1]
    let second: Double = h * h
    return first / second
}

let matrix: Matrix = .init(upperDiag: Array(repeating: 1, count: n - 2),
                           centerDiag: Array(repeating: 4, count: n - 1),
                           lowerDiag: Array(repeating: 1, count: n - 2))
// MARK: - Формирование прогочных коэф-тов

var alpha: [Double] = Array(repeating: 0, count: n - 1)
var betta: [Double] = Array(repeating: 0, count: n - 1)

alpha[0] = vector[0] / matrix[0, 0]
betta[0] = -matrix[0, 1] / matrix[0, 0]

for i in 1..<(n - 1) {
    let divider: Double = (matrix[i, i - 1] * betta[i - 1] + matrix[i, i])
    alpha[i] = (vector[i] - matrix[i, i - 1] * alpha[i - 1]) / divider
    betta[i] = i == n ? 0 : -matrix[i, i + 1] / divider
}

// MARK: - Вычисление корней

var cArray: [Double] = Array(repeating: 0, count: n + 1)

for i in stride(from: n - 2, to: 0, by: -1) {
    cArray[i] = alpha[i] + betta[i] * cArray[i + 1]
}

var aArray: [Double] = yArray
var bArray: [Double] = Array(repeating: 0, count: n + 1)
var dArray: [Double] = Array(repeating: 0, count: n + 1)

for i in 0...(n - 1) {
    bArray[i] = (yArray[i + 1] - yArray[i]) / h - h * (cArray[i + 1] - cArray[i]) / 3
    dArray[i] = (cArray[i + 1] - cArray[i]) / (3 * h)
}

// MARK: - Вычисление сплайнов

var splines: [Spline] = (0...n - 1).map { i in
        .init(a: aArray[i], b: bArray[i], c: cArray[i], d: dArray[i], range: (xArray[i]...xArray[i + 1]))
}

for i in 1...n {
    let x = a + Double(i) * h
    guard let splineValue = splines[i - 1].value(by: x - 0.5 * h) else {
        fatalError("spline range doesn't contain value: \(x)")
    }
    let originalValue = y(x: x - 0.5 * h)
    let diff = abs(splineValue - originalValue)
    
    guard let splineNodeValue = splines[i - 1].value(by: x) else {
        fatalError("spline range doesn't contain value: \(x)")
    }
    let originalNodeValue = y(x: x)
    let diffNode = abs(splineNodeValue - originalNodeValue)
    
    print(
        NSString(format: "%.5f", x),
        NSString(format: "%.5f", splineValue),
        NSString(format: "%.5f", originalValue),
        NSString(format: "%.5f", diff),
        NSString(format: "%.5f", splineNodeValue),
        NSString(format: "%.5f", originalNodeValue),
        NSString(format: "%.5f", diffNode)
    )
}

let value = 0.5
print(y(x: value))
print(splines.compactMap { $0.value(by: value) })



