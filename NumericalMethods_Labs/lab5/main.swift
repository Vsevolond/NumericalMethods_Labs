import Foundation

func f(_ point: (Float, Float)) -> Float {
    let (x, y) = point
    return sinf(x.pow(2)) + x.pow(4) + 2 * x.pow(2) * y.pow(4) + logf(1 + 0.1 * x)
}

func f_x(_ point: (Float, Float)) -> Float {
    let (x, y) = point
    return 2 * x * cosf(x.pow(2)) + 4 * x.pow(3) + 4 * x * y.pow(4) + 0.1 / (1 + 0.1 * x)
}

func f_y(_ point: (Float, Float)) -> Float {
    let (x, y) = point
    return 8 * x.pow(2) * y.pow(3)
}

func f_xx(_ point: (Float, Float)) -> Float {
    let (x, y) = point
    return -4 * x.pow(2) * sinf(x.pow(2)) + 2 * cosf(x.pow(2)) + 12 * x.pow(2) + 4 * y.pow(4) - 0.01 / (1 + 0.1 * x).pow(2)
}

func f_yy(_ point: (Float, Float)) -> Float {
    let (x, y) = point
    return 24 * x.pow(2) * y.pow(2)
}

func f_xy(_ point: (Float, Float)) -> Float {
    let (x, y) = point
    return 16 * x * y.pow(3)
}

func gradf(_ point: (Float, Float)) -> (x: Float, y: Float) { (f_x(point), f_y(point)) }

var point: (x: Float, y: Float) = (0, 0)
let eps: Float = 0.001
let analytic: (x: Float, y: Float) = (-0.05, 0)

var grad = gradf(point)
var k: Int = 0

while max(abs(grad.x), abs(grad.y)) >= eps {
    let u1 = f_x(point).pow(2) + f_y(point).pow(2)
    let u2 = f_xx(point) * f_x(point).pow(2) + 2 * f_xy(point) * f_x(point) * f_y(point) + f_yy(point) * f_y(point).pow(2)
    
    let tMin: Float = u1 / u2
    point = (point.x - tMin * f_x(point), point.y - tMin * f_y(point))
    grad = gradf(point)
    k += 1
}

print(k)
print(point)
print(abs(analytic.x - point.x), abs(analytic.y - point.y))
