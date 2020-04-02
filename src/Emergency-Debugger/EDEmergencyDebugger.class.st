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
		'debugAPI',
		'actions',
		'actionsDescriptions'
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

{ #category : #actions }
EDEmergencyDebugger >> availableActions [ 
	^actions ifNil:[actions := self buildDefaultActions]
]

{ #category : #actions }
EDEmergencyDebugger >> availableActionsDescriptions [ 
	^actionsDescriptions ifNil:[actionsDescriptions := self buildDefaultActionsDescriptions]
]

{ #category : #actions }
EDEmergencyDebugger >> buildDefaultActions [
	|dic|
	dic := Dictionary new.
	dic at: Character escape put: [ debugAPI terminateSession ].
	dic at: 'exit' put: [ debugAPI terminateSession ].
	dic at: 'retry' put: [ debugAPI tryReopenSessionWithDebugger ].
	dic at: Character arrowUp put: [ self moveUpInStack ].
	dic at: Character arrowDown put: [ self moveDownInStack ].
	dic at: Character arrowLeft put: [ "self showMoreRecentMethodVersion "].
	dic at: Character arrowRight put: [ "self showOlderMethodVersion "].
	dic at: 'revert' put: [ '' ].
	dic at: 'killAll' put: [ '' ].
	^dic
]

{ #category : #actions }
EDEmergencyDebugger >> buildDefaultActionsDescriptions [
	|dic|
	dic := Dictionary new.
	dic at: '<ESCAPE>' put: 'Exits the emergency debugger'.
	dic at: 'exit' put: 'Exits the emergency debugger'.
	dic at: 'retry' put: 'Retry opening a graphical debugger'.
	dic at: '<UP/DOWN ARROWS>' put: 'Move up/down in the stack'.
	dic at: '<RIGHT/LEFT ARROWS>' put: 'Navigate the current method versions'.
	dic at: 'revert' put: 'Revert the current method to the selected version'.
	dic at: 'killAll' put: 'Terminate all non-essential processes (will terminate Ed)'.
	^dic
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> composeHelpText [
	| str |
	str := self newTextStream.
	self availableActionsDescriptions
		keysAndValuesDo: [ :cmd :desc | 
			|text|
			text := (cmd, ': ') asText allBold, desc asText.
			text makeAllColor: rawDisplay gray.
			str << text.		
			str cr ].
	^ self composeResult: str contents title: 'HELP'
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> composeMethodText [
	| str stack context node text |
	str := self newTextStream.
	self writeSectionTitle: 'SOURCE' on: str.
	stack := debugAPI stack.
	context := stack at: stackSelectionIndex.
	node := debugAPI nodeForContext: context.
	text := context method sourceCode asText.
	text makeBoldFrom: 1 to: context method selector size + 1.
	text makeColor: rawDisplay red from: node start to: node stop.
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
	self composeHelpText.
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

{ #category : #accessing }
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

{ #category : #evaluation }
EDEmergencyDebugger >> performActionForChar: aCharacter [
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> separator [ 
	^'--------------------' asText makeAllColor: rawDisplay gray
]

{ #category : #initialization }
EDEmergencyDebugger >> terminate [
	isRunning := false
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
	aStream <<( aString asText makeAllColor: rawDisplay gray).
	aStream cr.
	self writeSeparatorOn: aStream
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> writeSeparatorOn: aStream [
	aStream << self separator.
	aStream cr
]
