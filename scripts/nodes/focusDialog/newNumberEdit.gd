extends PanelContainer
class_name NewNumberEdit

const FNUMBEREDIT:Font = preload("res://resources/fonts/fNumberEdit.tres")

enum CURSOR_MODE {NORMAL, NUMBER}

var cursorMode:CURSOR_MODE = CURSOR_MODE.NORMAL:
	set(to):
		cursorMode = to
		match cursorMode:
			CURSOR_MODE.NUMBER: %cursor.color = Color("#0083fd88")
			_: %cursor.color = Color("#00ffffaa")
var cursorStart:int = 0
var cursorEnd:int = 0

var cursorSelectedNumber:int = 0 # used in NUMBER mode

var text:String = ""
var textLen:int = 0

var numbers:int = 0
var numberStarts:Array[int] = []
var numberEnds:Array[int] = []
var numberValues:Array[int] = []
var numberSemiNegative:Array[bool] = [] # if a number is negative but like only kinda (the - is instead of a + of the number before it, not part of the number)
var texts:Array[String] = [] # one at the start and one after each number. may be empty

func _ready() -> void:
	parseText()
	buildText()

enum TOKEN {NUMBER, LBRACKET, RBRACKET, CROSS, DASH, X, SLASH, I}

func parseText() -> void:
	textLen = len(text)
	# tokenize; extract numbers
	var i:int = 0
	var thisNumberStart:int = -1 # -1 for not currently parsing a number
	var previousNumberEnd:int = 0
	numberStarts.clear()
	numberEnds.clear()
	numberValues.clear()
	numberSemiNegative.clear()
	texts.clear()
	numbers = 0
	var isNumber:bool
	var tokens:Array[Array] = [] # array[array[token type, data?]]
	for symbol in text + " ":
		isNumber = "0123456789".contains(symbol) or (!isNumber and symbol == "-" and i + 1 != textLen and "0123456789".contains(text[i+1]))
		# end of text
		if previousNumberEnd != -1 and isNumber or i == textLen:
			texts.append(text.substr(previousNumberEnd, i-previousNumberEnd))
		if isNumber:
			# start of number
			if thisNumberStart == -1:
				numbers += 1
				numberStarts.append(i)
				numberSemiNegative.append(i > 0 && text[i-1] == "-")
				thisNumberStart = i
				previousNumberEnd = -1
		else:
			# end of number
			if thisNumberStart != -1:
				var value:int = text.substr(thisNumberStart,i-thisNumberStart).to_int()
				numberEnds.append(i)
				numberValues.append(value)
				thisNumberStart = -1
				previousNumberEnd = i
				tokens.append([TOKEN.NUMBER, value])
			match symbol:
				"(": tokens.append([TOKEN.LBRACKET])
				")": tokens.append([TOKEN.RBRACKET])
				"+": tokens.append([TOKEN.CROSS])
				"-": tokens.append([TOKEN.DASH])
				"x": tokens.append([TOKEN.X])
				"/": tokens.append([TOKEN.SLASH])
				"i": tokens.append([TOKEN.I])
		i += 1
	print(textLen, numberStarts, numberEnds, numberValues, texts)
	# build tree

# 2+3i)/7
# p(2 + 3 i ) / 7)
# p(div{2 + 3 i, p(7)})
# p(div{add{p(2), p(3 i)}, p(7)})
# p(div{add{[2], [3i]}, [7]})

# Sum     ← Iprod (('+' / '-') Sum)
# Iprod   ← Product 'i'?
# Product ← Value (('*' / '/') Product)
# Value   ← [0-9]+ / '(' Sum ')'

func buildText() -> void:
	var formattedText:String = texts[0]
	for i in numbers:
		formattedText += "[color=ffffff]%s[/color]" % numberValues[i]
		formattedText += texts[i+1]
	%drawText.text = formattedText
	text = %drawText.get_parsed_text()
	placeCursor()

func receiveKey(key:InputEventKey) -> bool:
	Game.editor.grab_focus()
	match key.keycode:
		KEY_RIGHT:
			cursorMode = CURSOR_MODE.NORMAL
			if Input.is_key_pressed(KEY_SHIFT):
				if Input.is_key_pressed(KEY_CTRL): cursorEnd = nextPointOfInterest()
				else: cursorEnd = min(textLen, cursorEnd+1)
			else:
				if cursorEnd > cursorStart: cursorStart = cursorEnd
				elif cursorStart < textLen:
					if Input.is_key_pressed(KEY_CTRL): cursorStart = nextPointOfInterest()
					else: cursorStart += 1
					cursorEnd = cursorStart
					numberCaptureCursor(cursorStart)
			placeCursor()
		KEY_LEFT:
			cursorMode = CURSOR_MODE.NORMAL
			if Input.is_key_pressed(KEY_SHIFT):
				if Input.is_key_pressed(KEY_CTRL): cursorStart = previousPointOfInterest()
				else: cursorStart = max(0, cursorStart-1)
			else:
				if cursorEnd > cursorStart: cursorEnd = cursorStart
				elif cursorStart > 0:
					if Input.is_key_pressed(KEY_CTRL): cursorStart = previousPointOfInterest()
					else: cursorStart -= 1
					cursorEnd = cursorStart
					numberCaptureCursor(cursorStart)
			placeCursor()
		KEY_UP:
			match cursorMode:
				CURSOR_MODE.NORMAL:
					for number in numbers:
						if numberStarts[number] >= cursorStart && numberEnds[number] <= cursorEnd: changeNumber(number, 1)
					buildText()
				CURSOR_MODE.NUMBER:
					changeNumber(cursorSelectedNumber, 1)
					numberCaptureCursor(cursorStart)
					buildText()
					buildText()
		KEY_DOWN:
			match cursorMode:
				CURSOR_MODE.NORMAL:
					for number in numbers:
						if numberStarts[number] >= cursorStart && numberEnds[number] <= cursorEnd: changeNumber(number, -1)
					buildText()
				CURSOR_MODE.NUMBER:
					changeNumber(cursorSelectedNumber, -1)
					numberCaptureCursor(cursorStart)
					buildText()
		KEY_TAB:
			match cursorMode:
				_:
					if Input.is_key_pressed(KEY_SHIFT):
						for number in range(numbers,0,-1): if numberStarts[number-1] < cursorStart:
							numberCaptureCursor(numberStarts[number-1]); break
					else:
						for number in numbers: if numberEnds[number] > cursorEnd:
							numberCaptureCursor(numberStarts[number]); break
			placeCursor()
		KEY_A:
			if Input.is_key_pressed(KEY_CTRL):
				cursorMode = CURSOR_MODE.NORMAL
				cursorStart = 0
				cursorEnd = textLen
				placeCursor()
		KEY_BACKSPACE:
			if text == "": return true
			match cursorMode:
				CURSOR_MODE.NORMAL:
					if cursorEnd == cursorStart:
						var prevStart:int = cursorStart
						if Input.is_key_pressed(KEY_CTRL): cursorStart = previousPointOfInterest()
						else: cursorStart -= 1
						text = text.erase(cursorStart, prevStart-cursorStart)
						cursorEnd = cursorStart
						parseText()
						buildText()
					else:
						text = text.erase(cursorStart, cursorEnd - cursorStart)
						cursorEnd = cursorStart
						parseText()
						buildText()
				CURSOR_MODE.NUMBER:
					if numberValues[cursorSelectedNumber] == 0 or Input.is_key_pressed(KEY_CTRL):
						cursorMode = CURSOR_MODE.NORMAL
						text = text.erase(cursorStart, cursorEnd - cursorStart)
						cursorEnd = cursorStart
						parseText()
						buildText()
					else:
						setNumber(cursorSelectedNumber, 0)
						numberCaptureCursor(cursorStart)
						buildText()
		_:
			match cursorMode:
				CURSOR_MODE.NORMAL:
					if key.keycode >= 32 and key.keycode < 128:
						var character:String = char(key.unicode)
						if cursorEnd > cursorStart:
							text = text.erase(cursorStart, cursorEnd - cursorStart)
						elif "0123456789".contains(character):
							var endNumber:int = numberEnds.find(cursorStart)
							if endNumber != -1:
								setNumber(endNumber, numberValues[endNumber]*10+character.to_int())
								cursorStart = numberValues[endNumber]
								cursorEnd = cursorStart
								buildText()
								return true
							var startNumber:int = numberStarts.find(cursorStart)
							if startNumber != -1:
								setNumber(startNumber, character.to_int()*(10**len(numberValues[startNumber])) + numberValues[startNumber])
								cursorStart += 1
								cursorEnd = cursorStart
								buildText()
								return true
						text = text.insert(cursorStart, character)
						cursorStart += 1
						cursorEnd = cursorStart
						parseText()
						buildText()
				CURSOR_MODE.NUMBER:
					if Editor.eventIs(key, &"numberTimesI"): pass
					elif Editor.eventIs(key, &"numberNegate"):
						setNumber(cursorSelectedNumber, -numberValues[cursorSelectedNumber])
						numberCaptureCursor(cursorStart)
						buildText()
					else: return false
	return true

## for ctrl+right
func nextPointOfInterest() -> int:
	var pointOfInterest:int = textLen
	for number in numbers:
		if numberEnds[number] > cursorEnd: pointOfInterest = min(numberEnds[number], pointOfInterest)
		if numberStarts[number] > cursorEnd: pointOfInterest = min(numberStarts[number], pointOfInterest)
	return pointOfInterest

## for ctrl+left
func previousPointOfInterest() -> int:
	var pointOfInterest:int = 0
	for number in numbers:
		if numberEnds[number] < cursorStart: pointOfInterest = max(numberEnds[number], pointOfInterest)
		if numberStarts[number] < cursorStart: pointOfInterest = max(numberStarts[number], pointOfInterest)
	return pointOfInterest

func changeNumber(number:int, by:int) -> void:
	if numberSemiNegative[number]: setNumber(number, numberValues[number] - by)
	else: setNumber(number, numberValues[number] + by)

func setNumber(number:int, to:int) -> void:
	var prevLen:int = numberEnds[number] - numberStarts[number]
	numberValues[number] = to
	numberCheckSign(number)
	var lenChange:int = len(str(numberValues[number])) - prevLen
	numberEnds[number] += lenChange
	for shiftedNumber in range(number+1, numbers):
		numberStarts[shiftedNumber] += lenChange
		numberEnds[shiftedNumber] += lenChange
	textLen += lenChange

func numberCheckSign(number:int) -> void:
	if numberSemiNegative[number]:
		if numberValues[number] <= 0:
			numberValues[number] *= -1
			texts[number][-1] = "+"
			numberSemiNegative[number] = false
	else:
		if numberValues[number] < 0 and texts[number][-1] == "+":
			numberValues[number] *= -1
			texts[number][-1] = "-"
			numberSemiNegative[number] = true


func numberCaptureCursor(fromPosition:int) -> void:
	for number in numbers:
		if fromPosition >= numberStarts[number] and fromPosition <= numberEnds[number]:
			cursorStart = numberStarts[number]
			cursorEnd = numberEnds[number]
			cursorSelectedNumber = number
			cursorMode = CURSOR_MODE.NUMBER
			return

func placeCursor() -> void:
	%cursor.position.x = FNUMBEREDIT.get_string_size(text.substr(0,cursorStart)).x - 1
	%cursor.size.x = FNUMBEREDIT.get_string_size(text.substr(0,cursorEnd)).x - %cursor.position.x + 1
