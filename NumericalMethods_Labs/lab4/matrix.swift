import Foundation

class Matrix {
    
    private var upperDiag: [Float]
    private var centerDiag: [Float]
    private var lowerDiag: [Float]
    
    var size: Int { centerDiag.count }
    
    init(upperDiag: [Float], centerDiag: [Float], lowerDiag: [Float]) {
        self.upperDiag = upperDiag
        self.centerDiag = centerDiag
        self.lowerDiag = lowerDiag
    }
    
    subscript(row: Int, col: Int) -> Float {
        guard abs(row - col) <= 1, row.in(0..<size), col.in(0..<size) else {
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
