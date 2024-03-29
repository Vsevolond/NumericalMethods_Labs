import Foundation

let p: Float = 0
let q: Float = 1
let derivedY0: Float = -3

func f(x: Float) -> Float { 4 * expf(x) }
func y(x: Float) -> Float { 2 * cosf(x) - 5 * sinf(x) + 2 * expf(x) }

let a: Float = y(x: 0)
let b: Float = y(x: 1)

let n: Int = 10
let h: Float = 1 / Float(n)

let xArray: Vector = .init(array: (0...n).map { Float($0) * h })
let fArray: Vector = xArray.map { f(x: $0) }
let yArray: Vector = xArray.map { y(x: $0) }

let vector: Vector = fArray.map { $0 * h * h }

let matrix: Matrix = .init(
    upperDiag: .init(repeating: 1 + h * p / 2, count: n),
    centerDiag: .init(repeating: h * h * q - 2, count: n + 1),
    lowerDiag: .init(repeating: 1 - h * p / 2, count: n)
)

let alpha: Vector = .init(size: n + 1)
let betta: Vector = .init(size: n + 1)

alpha[0] = -derivedY0 * h
betta[0] = 1

for i in 1...n {
    let divider: Float = (matrix[i, i - 1] * betta[i - 1] + matrix[i, i])
    alpha[i] = (vector[i] - matrix[i, i - 1] * alpha[i - 1]) / divider
    betta[i] = -matrix[i, i + 1] / divider
}

var _yArray: Vector = .init(size: n + 1)
_yArray[0] = a
_yArray[n] = b

for i in stride(from: n - 1, through: 1, by: -1) {
    _yArray[i] = alpha[i] + betta[i] * _yArray[i + 1]
}

_yArray -= yArray
let inaccuracy: Float = _yArray.absolute().max

print(inaccuracy)
