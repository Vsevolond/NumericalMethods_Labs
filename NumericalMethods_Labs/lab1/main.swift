import Foundation
import Accelerate

// MARK: - Help Entities

class Matrix {
    
    var upperDiag: [Double]
    var centerDiag: [Double]
    var lowerDiag: [Double]
    
    var size: Int {
        centerDiag.count
    }
    
    var full: [[Double]] {
        var result: [[Double]] = Array(repeating: Array(repeating: 0, count: size), count: size)
        for i in 0..<(size - 1) {
            result[i][i] = centerDiag[i]
            result[i][i + 1] = upperDiag[i]
            result[i + 1][i] = lowerDiag[i]
        }
        
        result[size - 1][size - 1] = centerDiag[size - 1]
        
        return result
    }
    
    init(upperDiag: [Double], centerDiag: [Double], lowerDiag: [Double]) {
        self.upperDiag = upperDiag
        self.centerDiag = centerDiag
        self.lowerDiag = lowerDiag
    }
    
    subscript(row: Int, col: Int) -> Double {
        guard abs(row - col) <= 1 else {
            return 0
        }
        
        if row == col {
            return centerDiag[row]
        } else if row > col {
            return lowerDiag[row - 1]
        } else {
            return upperDiag[col - 1]
        }
    }
}

extension Matrix {
    
    static func *= (matrix: inout Matrix, scalar: Double) {
        for i in 0..<matrix.centerDiag.count {
            matrix.centerDiag[i] *= scalar
        }
        
        for i in 0..<matrix.upperDiag.count {
            matrix.upperDiag[i] *= scalar
        }
        
        for i in 0..<matrix.lowerDiag.count {
            matrix.lowerDiag[i] *= scalar
        }
    }
}

// MARK: - Help Functions

func invert(matrix : [[Double]], size: Int) -> [[Double]] {
    var inMatrix = matrix.flatMap { $0 }
    var N = __CLPK_integer(sqrt(Double(size)))
    var pivots = [__CLPK_integer](repeating: 0, count: Int(N))
    var workspace = [Double](repeating: 0.0, count: Int(N))
    var error : __CLPK_integer = 0

    withUnsafeMutablePointer(to: &N) {
        dgetrf_($0, $0, &inMatrix, $0, &pivots, &error)
        dgetri_($0, &inMatrix, $0, &pivots, &workspace, $0, &error)
    }
    return stride(from: 0, to: inMatrix.count, by: size).map {
        Array(inMatrix[$0..<$0 + size])
    }
}

func multiplyOf(matrix: [[Double]], vector: [Double]) -> [Double] {
    var result: [Double] = Array(repeating: 0, count: vector.count)
    (0..<matrix.count).forEach { index in
        result[index] = multiplyOf(vector1: matrix[index], vector2: vector)
    }
    
    return result
}

func multiplyOf(vector1: [Double], vector2: [Double]) -> Double {
    var result: Double = 0
    (0..<vector1.count).forEach { index in
        result += vector1[index] * vector2[index]
    }
    
    return result
}

func substractionOf(vector1: [Double], vector2: [Double]) -> [Double] {
    return (0..<vector1.count).map { index in
        vector1[index] - vector2[index]
    }
}

// MARK: - Метод прогонки для решения СЛАУ (с трехдиагональной матрицей)

var matrixA: Matrix = .init(upperDiag: [1, 1, 1], centerDiag: [4, 4, 4, 4], lowerDiag: [1, 1, 1])
//matrixA *= 1.0/3.0

let vectorB: [Double] = [2, 4, 6.0 + 2.0 / 3.0, 9] // [5, 6, 6, 5]

let n = matrixA.size

// MARK: - Формирование прогочных коэф-тов

var alpha: [Double] = Array(repeating: 0, count: n)
var betta: [Double] = Array(repeating: 0, count: n)

alpha[0] = vectorB[0] / matrixA[0, 0]
betta[0] = -matrixA[0, 1] / matrixA[0, 0]

for i in 1...(n - 1) {
    let divider: Double = (matrixA[i, i - 1] * betta[i - 1] + matrixA[i, i])
    alpha[i] = (vectorB[i] - matrixA[i, i - 1] * alpha[i - 1]) / divider
    betta[i] = i == n - 1 ? 0 : -matrixA[i, i + 1] / divider
}

// MARK: - Вычисление корней

var vectorX: [Double] = Array(repeating: 0, count: n)

vectorX[n - 1] = alpha[n - 1]

for i in stride(from: n - 2, to: -1, by: -1) {
    vectorX[i] = alpha[i] + betta[i] * vectorX[i + 1]
}

let newVectorB = multiplyOf(matrix: matrixA.full, vector: vectorX)
let diff = substractionOf(vector1: newVectorB, vector2: vectorB)

let invertedMatrixA = invert(matrix: matrixA.full, size: n)
let offset = multiplyOf(matrix: invertedMatrixA, vector: diff)

let correctVectorX = substractionOf(vector1: vectorX, vector2: offset)

print(offset)
print(correctVectorX)

