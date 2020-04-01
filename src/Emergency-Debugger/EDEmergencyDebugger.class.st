"
I am a REPL debugger and I provide an access to the Sindarin debugging API.
I do not depend on morphic, and while I depend on Color, I can work without it.

I use a ReadWriteStream to handle user input and output my results.
I use Display and DisplayScreen to show my results.
"
Class {
	#name : #EDEmergencyDebugger,
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
		'isRunning',
		'debugAPI'
	],
	#classVars : [
		'DefaultDebugAPI'
	],
	#category : #'Emergency-Debugger'
}

{ #category : #'instance creation' }
EDEmergencyDebugger class >> debug: aDebugSession [
	^ self new debug: aDebugSession
]

{ #category : #accessing }
EDEmergencyDebugger class >> debugAPI [
	^self defaultDebugAPI
]

{ #category : #accessing }
EDEmergencyDebugger class >> defaultDebugAPI [
	^ DefaultDebugAPI ifNil: [ DefaultDebugAPI := EDDebuggingAPI ]
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> composeHelpText [
	| str |
	str := self newTextStream.
	str << 'exit: terminate the debug session and exit the debugger' asText.
	str cr.
	str << 'proceed: proceeds the execution' asText.
	str cr.
	str << 'revert: revert the selected method to its last known version' asText.
	^self composeResult: str contents title: 'HELP'
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> composeMethodText [
	| str stack context node text |
	str := self newTextStream.
	self writeSectionTitle: 'SOURCE' on: str.
	stack := debugAPI stack.
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
EDEmergencyDebugger >> composePromptWith: aString [
	| str  |
	str := self newTextStream.	
	str cr.
	self writeSeparatorOn: str.
	str << '> ' asText allBold.
	str << aString trim asText.
	input := str contents
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> composeResult: text title: title [
	| str |
	str := self newTextStream.
	str cr.
	self writeSectionTitle: title on: str.
	str << text.
	result := str contents
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> composeStackText [
	| str stack |
	str := self newTextStream.
	stack := debugAPI stack.
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
EDEmergencyDebugger >> composeTitleText [
	titleText := 'Hi, I''m ED - What is the nature of your debugging emergency?' asText allBold
]

{ #category : #initialization }
EDEmergencyDebugger >> debug: aDebugSession [
	debugAPI := self class debugAPI attachTo: aDebugSession.
	debugAPI debugger: self.
	isRunning := true.
	self composeTitleText.
	self composeStackText.
	self composeMethodText.
	self composePromptWith: ''.
	self updateDisplay.
	repl readEvalPrint 
]

{ #category : #evaluation }
EDEmergencyDebugger >> eval: command [
	command = 'exit'
		ifTrue: [ self terminate ].
	command = 'h' ifTrue:[self composeHelpText].
	self composePromptWith: ''.
	self updateDisplay
]

{ #category : #initialization }
EDEmergencyDebugger >> initialize [
	repl := EDREPLInterface forDebugger: self.
	rawDisplay := EDDisplayInterface new.
	stackSelectionIndex := 1.
	input := Text new.
	self composeResult: Text new title: 'TYPE h FOR HELP' asText.
	isRunning := false
]

{ #category : #'debugging support' }
EDEmergencyDebugger >> isRunning [
	^isRunning 
]

{ #category : #stack }
EDEmergencyDebugger >> moveDownInStack [
	stackSelectionIndex := (stackSelectionIndex + 1) min: debugAPI maxStackSize.
	self composeStackText.
	self composeMethodText  

]

{ #category : #stack }
EDEmergencyDebugger >> moveUpInStack [
	stackSelectionIndex := (stackSelectionIndex - 1) max: 1.
	self composeStackText.
	self composeMethodText  

]

{ #category : #'text - composing' }
EDEmergencyDebugger >> newTextStream [
	^WriteStream on: Text new
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> separator [ 
	^'--------------------' asText makeAllColor: Color gray
]

{ #category : #'debugging support' }
EDEmergencyDebugger >> terminate [
	isRunning := false.
	self currentWorld restoreMorphicDisplay.
	"sindarinDebugger debugSession terminate"
]

{ #category : #updating }
EDEmergencyDebugger >> updateDisplay [
	rawDisplay clear.
	rawDisplay show: (titleText , stackText, methodText, input, result )

]

{ #category : #updating }
EDEmergencyDebugger >> updatePrompt: aString [
	self composePromptWith: aString.
	self updateDisplay
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> writeSectionTitle: aString on: aStream [
	self writeSeparatorOn: aStream.
	aStream <<( aString asText makeAllColor: Color gray).
	aStream cr.
	self writeSeparatorOn: aStream
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> writeSeparatorOn: aStream [
	aStream << self separator.
	aStream cr
]
