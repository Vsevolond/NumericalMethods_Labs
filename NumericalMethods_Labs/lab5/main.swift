import Foundation

func f(_ point: (x1: Float, x2: Float)) -> Float {
    let (x1, x2) = point
    return sinf(x1.pow(2)) + x1.pow(4) + 2 * x1.pow(2) * x2.pow(4) + logf(1 + 0.1 * x1)
}

func f_x1(_ point: (x1: Float, x2: Float)) -> Float {
    let (x1, x2) = point
    return 2 * x1 * cosf(x1.pow(2)) + 4 * x1.pow(3) + 4 * x1 * x2.pow(4) + 0.1 / (1 + 0.1 * x1)
}

func f_x2(_ point: (x1: Float, x2: Float)) -> Float {
    let (x1, x2) = point
    return 8 * x1.pow(2) * x2.pow(3)
}

func f_x1_x1(_ point: (x1: Float, x2: Float)) -> Float {
    let (x1, x2) = point
    return -4 * x1.pow(2) * sinf(x1.pow(2)) + 2 * cosf(x1.pow(2)) + 12 * x1.pow(2) + 4 * x2.pow(4) - 0.01 / (1 + 0.1 * x1).pow(2)
}

func f_x2_x2(_ point: (x1: Float, x2: Float)) -> Float {
    let (x1, x2) = point
    return 24 * x1.pow(2) * x2.pow(2)
}

func f_x1_x2(_ point: (x1: Float, x2: Float)) -> Float {
    let (x1, x2) = point
    return 16 * x1 * x2.pow(3)
}

func gradf(_ point: (x1: Float, x2: Float)) -> (x1: Float, x2: Float) {
    (f_x1(point), f_x2(point))
}

var point: (x1: Float, x2: Float) = (0, 0)

let eps: Float = 0.001
var grad = gradf(point)
var k = 0

while max(abs(grad.x1), abs(grad.x2)) >= eps {
    let u1 = -f_x1(point).pow(2) - f_x2(point).pow(2)
    let u2 = f_x1_x1(point) * f_x1(point).pow(2) + 2 * f_x1_x2(point) * f_x1(point) * f_x2(point) + f_x2_x2(point) * f_x2(point).pow(2)
    
    let t = -u1 / u2
    
    
    point.x1 = point.x1 - t * f_x1(point)
    point.x2 = point.x2 - t * f_x2(point)
    grad = gradf(point)
    k += 1
}

print(point)
print(k)
