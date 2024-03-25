import Foundation

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
