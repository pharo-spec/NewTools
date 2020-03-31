"
I am a REPL debugger and I provide an access to the Sindarin debugging API.
I do not depend on morphic, and while I depend on Color, I can work without it.

I use a ReadWriteStream to handle user input and output my results.
I use Display and DisplayScreen to show my results.
"
Class {
	#name : #SindarinEmergencyDebugger,
	#superclass : #Object,
	#instVars : [
		'sindarinDebugger',
		'rawDisplay',
		'stackSelectionIndex',
		'methodText',
		'stackText',
		'titleText',
		'repl',
		'input',
		'result',
		'isRunning'
	],
	#category : #'NewTools-Sindarin-Emergency-Debugger'
}

{ #category : #'instance creation' }
SindarinEmergencyDebugger class >> debug: aDebugSession [
	^ self new debug: aDebugSession
]

{ #category : #accessing }
SindarinEmergencyDebugger class >> displayStackSize [
	^5
]

{ #category : #'text - composing' }
SindarinEmergencyDebugger >> composeHelpText [
	| str |
	str := self newTextStream.
	str cr.
	self writeSectionTitle: 'HELP' on: str.
	str << 'exit: terminate the debug session and exit the debugger' asText.
	str cr.
	str << 'proceed: proceeds the execution' asText.
	str cr.
	str << 'revert: revert the selected method to its last known version' asText.
	^str contents
]

{ #category : #'text - composing' }
SindarinEmergencyDebugger >> composeMethodText [
	| str stack context node text |
	str := self newTextStream.
	self writeSectionTitle: 'SOURCE' on: str.
	stack := sindarinDebugger debugSession stackOfSize: self maxStackSize.
	context := stack at: stackSelectionIndex.
	node := sindarinDebugger nodeForContext: context.
	text := context method sourceCode asText.
	text makeBoldFrom: 1 to: context method selector size + 1.
	text makeColor: Color red from: node start to: node stop.
	str << text.
	str cr.
	methodText := str contents
]

{ #category : #'text - composing' }
SindarinEmergencyDebugger >> composePromptWith: aString [
	| str  |
	str := self newTextStream.	
	str cr.
	self writeSeparatorOn: str.
	str << '> ' asText allBold.
	str << aString trim asText.
	input := str contents
]

{ #category : #'text - composing' }
SindarinEmergencyDebugger >> composeStackText [
	| str stack |
	str := self newTextStream.
	stack := sindarinDebugger debugSession stackOfSize: self maxStackSize.
	str cr.
	self writeSectionTitle: 'STACK' on: str.
	1 to: stack size do: [ :i | 
		| text |
		text := (stack at: i) method name asText.
		stackSelectionIndex = i
			ifTrue: [ text allBold ].
		str << text.
		str cr ].
	stackText := str contents
]

{ #category : #'text - composing' }
SindarinEmergencyDebugger >> composeTitleText [
	titleText := 'ED - your emergency debugger. Type h for help!' asText allBold
]

{ #category : #initialization }
SindarinEmergencyDebugger >> debug: aDebugSession [
	sindarinDebugger := SindarinDebugger attachTo: aDebugSession.
	isRunning := true.
	self composeTitleText.
	self composeStackText.
	self composeMethodText.
	self composePromptWith: ''.
	self updateDisplay.
	repl readEvalPrint 
]

{ #category : #evaluation }
SindarinEmergencyDebugger >> eval: command [
	command = 'exit'
		ifTrue: [ self terminate ].
	command = 'h' ifTrue:[result := self composeHelpText].
	self composePromptWith: ''.
	self updateDisplay
]

{ #category : #initialization }
SindarinEmergencyDebugger >> initialize [
	repl := SEDREPLInterface forDebugger: self.
	rawDisplay := SEDDisplayInterface new.
	stackSelectionIndex := 1.
	input := Text new.
	result := Text new.
	isRunning := false
]

{ #category : #'debugging support' }
SindarinEmergencyDebugger >> isRunning [
	^isRunning 
]

{ #category : #stack }
SindarinEmergencyDebugger >> maxStackSize [
	^self class displayStackSize
]

{ #category : #stack }
SindarinEmergencyDebugger >> moveDownInStack [
	stackSelectionIndex := (stackSelectionIndex + 1) min: self maxStackSize.
	self composeStackText.
	self composeMethodText  

]

{ #category : #stack }
SindarinEmergencyDebugger >> moveUpInStack [
	stackSelectionIndex := (stackSelectionIndex - 1) max: 1.
	self composeStackText.
	self composeMethodText  

]

{ #category : #'text - composing' }
SindarinEmergencyDebugger >> newTextStream [
	^WriteStream on: Text new
]

{ #category : #'text - composing' }
SindarinEmergencyDebugger >> separator [ 
	^'--------------------' asText makeAllColor: Color gray
]

{ #category : #'debugging support' }
SindarinEmergencyDebugger >> terminate [
	isRunning := false.
	self currentWorld restoreMorphicDisplay.
	"sindarinDebugger debugSession terminate"
]

{ #category : #updating }
SindarinEmergencyDebugger >> updateDisplay [
	rawDisplay clear.
	rawDisplay show: (titleText , stackText, methodText, input, result )

]

{ #category : #updating }
SindarinEmergencyDebugger >> updatePrompt: aString [
	self composePromptWith: aString.
	self updateDisplay
]

{ #category : #'text - composing' }
SindarinEmergencyDebugger >> writeSectionTitle: aString on: aStream [
	self writeSeparatorOn: aStream.
	aStream <<( aString asText makeAllColor: Color gray).
	aStream cr.
	self writeSeparatorOn: aStream
]

{ #category : #'text - composing' }
SindarinEmergencyDebugger >> writeSeparatorOn: aStream [
	aStream << self separator.
	aStream cr
]
