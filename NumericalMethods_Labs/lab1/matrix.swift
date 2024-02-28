import Foundation
import Accelerate

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

