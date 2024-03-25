import Foundation

let xArray: [Float] = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
let yArray: [Float] = [3.21, 2.95, 4.06, 4.03, 5.39, 5.97, 6.51, 6.77, 7.79]//[1.32, 1.81, 2.58, 2.88, 3.88, 4.29, 4.58, 5.08, 4.14]

let n: Int = xArray.count
let m: Int = 4

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

var inaccuracy = variance / sqrtf(Float(n))
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

let approximateType = ApproximateType.getBy(type: funcType)
let zFunc = approximateType.function

let slau = SLAU(forType: approximateType, xArray: xArray, yArray: yArray)
let (alpha, betta) = slau.solution()

print("Значения a и b: ", alpha, betta)

middleValues = xArray.pairs().map { zFunc(alpha, betta, ($0 + $1) / 2) }
print("Значения в средних точках: ", middleValues)

variance = sqrtf(xArray.enumerated().map { index, x in
    (zFunc(alpha, betta, x) - yArray[index]).pow(2)
}.sum())
inaccuracy = variance / sqrtf(Float(n))
print("СКО: ", inaccuracy)
