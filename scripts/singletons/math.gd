extends Node

enum SYSTEM {COMPLEX, FRACTIONS}
var system:SYSTEM = SYSTEM.FRACTIONS
const HAS_FRACTIONS:int = 1

# COMPLEX: [a,b], represents a + bi

# FRACTIONS: [a,b,d], represents (a + bi)/d
# d cannot be 0 or negative

var ZERO:PackedInt64Array:
	get():
		match system:
			SYSTEM.COMPLEX: return [0,0]
			_: return [0,0,1]

var ONE:PackedInt64Array:
	get():
		match system:
			SYSTEM.COMPLEX: return [1,0]
			_: return [1,0,1]

var nONE:PackedInt64Array:
	get():
		match system:
			SYSTEM.COMPLEX: return [-1,0]
			_: return [-1,0,1]

var I:PackedInt64Array:
	get():
		match system:
			SYSTEM.COMPLEX: return [1,0]
			_: return [0,1,1]

var nI:PackedInt64Array:
	get():
		match system:
			SYSTEM.COMPLEX: return [1,0]
			_: return [0,-1,1]

# initialisers

# New number
func N(n:int) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [n, 0]
		_: return [n,0,1]

# New imaginary number
func Ni(n:int) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [0, n]
		_: return [0,n,1]

# New complex number
func Nc(a:int,b:int) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [a, b]
		_: return [a,b,1]

# New fractional number
func Nf(n:int,d:int) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: assert(false); return ZERO
		_: return [n,0,d]

# New fractional imaginary number
func Nfi(n:int,d:int) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: assert(false); return ZERO
		_: return [0,n,d]

# New fractional complex number
func Nfc(a:int,b:int,d:int) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: assert(false); return ZERO
		_: return [a,b,d]

# New Complex number from Numbers (a,b -> a[r] + b[r]i)
func Ncn(a:PackedInt64Array,b:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [a[0], b[0]]
		_: return simplify([a[0]*b[2], b[0]*a[2], a[2]*b[2]])

# New Fractional number from Numbers (a,b -> a[r] / b[r])
func Nfn(a:PackedInt64Array,b:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: assert(false); return ZERO
		_: return simplify([a[0],0,b[0]])

func allAxes() -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [1,1]
		_: return [1,1,1]

# operators

# (a,b -> a + b)
func add(a:PackedInt64Array, b:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [a[0]+b[0], a[1]+b[1]]
		_: return simplify([a[0]*b[2] + b[0]*a[2], a[1]*b[2] + b[1]*a[2], a[2]*b[2]])

# (a,b -> a - b)
func sub(a:PackedInt64Array, b:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [a[0]-b[0], a[1]-b[1]]
		_: return simplify([a[0]*b[2] - b[0]*a[2], a[1]*b[2] - b[1]*a[2], a[2]*b[2]])

# (a,b -> a * b)
func times(a:PackedInt64Array, b:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [a[0]*b[0]-a[1]*b[1], a[0]*b[1]+a[1]*b[0]]
		_: return simplify([a[0]*b[0]-a[1]*b[1], a[0]*b[1]+a[1]*b[0], a[2]*b[2]])

# (a,b -> a[r] * b[r] + (a[i] * b[i])i)
func across(a:PackedInt64Array, b:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [a[0]*b[0], a[1]*b[1]]
		_: return simplify([a[0]*b[0], a[1]*b[1], a[2]*b[2]])

# (a,b -> a / b)
# truncates if fractions are unrepresentable
func divide(a:PackedInt64Array, b:PackedInt64Array) -> PackedInt64Array:
	match system:
		@warning_ignore("integer_division") SYSTEM.COMPLEX: return [(a[0]*b[0]+a[1]*b[1])/(b[0]*b[0]+b[1]*b[1]), (a[1]*b[0]-a[0]*b[1])/(b[0]*b[0]+b[1]*b[1])]
		_: return simplify([(a[0]*b[0]+a[1]*b[1])*b[2], (a[1]*b[0]-a[0]*b[1])*b[2], (b[0]*b[0]+b[1]*b[1])*a[2]])

# (a,b -> a - floor(a/b)*b)
func modulo(a:PackedInt64Array, b:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [(a[0]*b[0]+a[1]*b[1])%(b[0]*b[0]+b[1]*b[1]), (a[1]*b[0]-a[0]*b[1])%(b[0]*b[0]+b[1]*b[1])]
		_: return simplify([((a[0]*b[0]+a[1]*b[1])*b[2])%((b[0]*b[0]+b[1]*b[1])*a[2]), ((a[1]*b[0]-a[0]*b[1])*b[2])%((b[0]*b[0]+b[1]*b[1])*a[2]), a[2]*b[2]])

# a "along" the axes of b
# (a,b -> (a[r] * sign(b[r])) + (a[i] * sign(b[i]))i)
func along(a:PackedInt64Array, b:PackedInt64Array) -> PackedInt64Array: return across(a, axis(b))
# a "along" the axes of b, ignoring signs
# (a,b -> (a[r] * exists(b[r])) + (a[i] * exists(b[i]))i)
func alongbs(a:PackedInt64Array, b:PackedInt64Array) -> PackedInt64Array: return across(a, axibs(b))

# (a -> -a)
func negate(n:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [-n[0], -n[1]]
		_: return [-n[0], -n[1], n[2]]

# (a -> ai)
func rotate(n:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [-n[1], n[0]]
		_: return [-n[1], n[0], n[2]]

# reducers

# (n -> n)
func simplify(n:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return n
		_:
			var divisor:int = gcd(gcd(n[0], n[1]), n[2])
			@warning_ignore("integer_division") return [n[0]/divisor, n[1]/divisor, n[2]/divisor]

# (n -> n[r])
func r(n:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [n[0], 0]
		_: return [n[0], 0, n[2]]

# (n -> n[i]i)
func i(n:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [0, n[1]]
		_: return [0, n[1], n[2]]

# (n -> n[i])
func ir(n:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [n[1], 0]
		_: return [n[1], 0, n[2]]

# (n -> sign(n[r]) + sign(n[i]))
func sign(n:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [sign(n[0])+sign(n[1]), 0]
		_: return [sign(n[0])+sign(n[1]), 0, 1]

# (n -> abs(n[r]) + abs(n[i]))
func abs(n:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [abs(n[0])+abs(n[1]), 0]
		_: return [abs(n[0])+abs(n[1]), 0, n[2]]

# (n -> n[r] + n[i])
func reduce(n:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [n[0]+n[1], 0]
		_: return [n[0]+n[1], 0, n[2]]

# the axes present in the number
# (n -> sign(n[r]) + sign(n[i])i)
func axis(n:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [sign(n[0]), sign(n[1])]
		_: return [sign(n[0]), sign(n[1]), 1]

# the axes present in the number, but 0+0i counts as positive real
# (n -> 1 if n == 0 else axis(n))
func saxis(n:PackedInt64Array) -> PackedInt64Array: return ONE if n == ZERO else axis(n)

# abs of axes independently
# (n -> abs(n[r]) + abs(n[i])i)
func acrabs(n:PackedInt64Array) -> PackedInt64Array:
	match system:
		SYSTEM.COMPLEX: return [abs(n[0]), abs(n[1])]
		_: return [abs(n[0]), abs(n[1]), n[2]]

# the axes present in the number, ignoring sign
func axibs(n:PackedInt64Array) -> PackedInt64Array: return acrabs(axis(n))

# comparators

# (a,b -> a == b)
func eq(a:PackedInt64Array, b:PackedInt64Array) -> bool: return a == b

# (a,b -> a != b)
func neq(a:PackedInt64Array, b:PackedInt64Array) -> bool: return a != b

# (a,b -> a[r] > b[r])
func gt(a:PackedInt64Array, b:PackedInt64Array) -> bool:
	match system:
		SYSTEM.COMPLEX: return a[0] > b[0]
		_: return a[0]*b[2] > b[0]*a[2]

# (a,b -> a[r] >= b[r])
func gte(a:PackedInt64Array, b:PackedInt64Array) -> bool: return !lt(a, b)

# (a,b -> a[r] < b[r])
func lt(a:PackedInt64Array, b:PackedInt64Array) -> bool:
	match system:
		SYSTEM.COMPLEX: return a[0] < b[0]
		_: return a[0]*b[2] < b[0]*a[2]

# (a,b -> a[r] <= b[r])
func lte(a:PackedInt64Array, b:PackedInt64Array) -> bool: return !gt(a, b)

# (a,b -> a[i] > b[i])
func igt(a:PackedInt64Array, b:PackedInt64Array) -> bool:
	match system:
		SYSTEM.COMPLEX: return a[1] > b[1]
		_: return a[1]*b[2] > b[1]*a[2]

# (a,b -> a[i] >= b[i])
func igte(a:PackedInt64Array, b:PackedInt64Array) -> bool: return !ilt(a, b)

# (a,b -> a[i] < b[i])
func ilt(a:PackedInt64Array, b:PackedInt64Array) -> bool:
	match system:
		SYSTEM.COMPLEX: return a[1] < b[1]
		_: return a[1]*b[2] < b[1]*a[2]

# (a,b -> a[i] <= b[i])
func ilte(a:PackedInt64Array, b:PackedInt64Array) -> bool: return !igt(a, b)

# (a,b -> floor(a / b) == a / b)
func divisibleBy(a:PackedInt64Array, b:PackedInt64Array) -> bool: return nex(modulo(a,b))

# (a,b -> exists(a[r]) implies exists(b[r]) and exists(a[i]) implies exists(b[i]))
func implies(a:PackedInt64Array, b:PackedInt64Array) -> bool:
	return (a[0] == 0 || b[0] != 0) && (a[1] == 0 || b[1] != 0)

# signed implies
# (a,b -> exists(a[r]) implies sign(a[r]) == sign(b[r]) and exists(a[i]) implies sign(a[i]) == sign(b[i]))
func simplies(a:PackedInt64Array, b:PackedInt64Array) -> bool:
	return (a[0] == 0 || sign(a[0]) == sign(b[0])) && (a[1] == 0 || sign(a[1]) == sign(b[1]))

# deciders

# "exists"
func ex(n:PackedInt64Array) -> bool:
	return neq(n, ZERO)

func nex(n:PackedInt64Array) -> bool:
	return eq(n, ZERO)

func isNonzeroReal(n:PackedInt64Array) -> bool:
	return n[0] and !n[1]

func isNonzeroImag(n:PackedInt64Array) -> bool:
	return !n[0] and n[1]

func isNonzeroAxial(n:PackedInt64Array) -> bool:
	return bool(n[0]) != bool(n[1])

func isComplex(n:PackedInt64Array) -> bool:
	return n[0] and n[1]

func positive(n:PackedInt64Array) -> bool:
	return n[0] > 0

func negative(n:PackedInt64Array) -> bool:
	return n[0] < 0

func nonPositive(n:PackedInt64Array) -> bool:
	return n[0] <= 0

func nonNegative(n:PackedInt64Array) -> bool:
	return n[0] >= 0

func hasPositive(n:PackedInt64Array) -> bool:
	return n[0] > 0 or n[1] > 0

func hasNegative(n:PackedInt64Array) -> bool:
	return n[0] < 0 or n[1] < 0

func hasNonPositive(n:PackedInt64Array) -> bool:
	return n[0] <= 0 or n[1] <= 0

func hasNonNegative(n:PackedInt64Array) -> bool:
	return n[0] >= 0 or n[1] >= 0

func isInteger(n:PackedInt64Array) -> bool:
	match system:
		SYSTEM.COMPLEX: return true
		_: return n[2] == 1

# util

func toIpow(n:PackedInt64Array) -> int:
	if eq(n, ONE): return 0
	elif eq(n, I): return 1
	elif eq(n, nONE): return 2
	elif eq(n, nI): return 3
	else: assert(false); return 0

# only needs to work for 1 and -1
func toInt(n:PackedInt64Array) -> int:
	return n[0]

func str(n:PackedInt64Array) -> String:
	return strWithInf(n,ZERO)

func strWithInf(n:PackedInt64Array,infAxes:PackedInt64Array) -> String:
	var rComponent:String
	var iComponent:String = ""
	if infAxes[0]: rComponent = "-~" if n[0] < 0 else "~"
	elif n[0]: rComponent = str(n[0])
	if n[1]:
		if n[1] > 0 and n[0]: iComponent += "+"
		if infAxes[1]: iComponent += "-~i" if n[1] < 0 else "~i"
		else: iComponent += str(n[1]) + "i"
	if !n[0] and !n[1]: return "0"
	if system & HAS_FRACTIONS and n[2] != 1: iComponent += "/" + str(n[2])
	return rComponent + iComponent

# greatest (positive) common divisor
# https://en.wikipedia.org/wiki/Euclidean_algorithm
func gcd(a:int, b:int) -> int:
	a = abs(a)
	b = abs(b)
	if a == 0: return b
	if b == 0: return a
	while b != 0:
		var temp:int = b
		b = a % b
		a = temp
	return a
