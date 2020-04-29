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
		'rawDisplay',
		'stackSelectionIndex',
		'methodVersionSelectionIndex',
		'methodText',
		'stackText',
		'titleText',
		'repl',
		'input',
		'result',
		'isRunning',
		'debugAPI',
		'actions',
		'actionsDescriptions',
		'selectedMethod',
		'shortStack',
		'shortStackIndex'
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
EDEmergencyDebugger class >> debugAPI: aDebugAPIClass [
	DefaultDebugAPI := aDebugAPIClass 
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
EDEmergencyDebugger >> availableActionsDescriptionsMap [
	^self buildDefaultActionsDescriptionsMap 
]

{ #category : #initialization }
EDEmergencyDebugger >> basicDebug: aDebugSession [
	debugAPI := self class debugAPI attachTo: aDebugSession.
	debugAPI debugger: self.
	isRunning := true
]

{ #category : #actions }
EDEmergencyDebugger >> buildDefaultActions [
	|dic|
	dic := Dictionary new.
	dic at: 'q!' put: [ debugAPI closeEmergencySession ].
	dic at: 'q' put: [ debugAPI terminateSession ].
	dic at: 'exit' put: [ debugAPI terminateSession ].
	dic at: 'retry' put: [ debugAPI tryReopenSessionWithDebugger ].
	dic at: Character arrowUp put: [ self moveUpInStack ].
	dic at: Character arrowDown put: [ self moveDownInStack ].
	dic at: Character arrowLeft put: [ self showMoreRecentMethodVersion ].
	dic at: Character arrowRight put: [ self showOlderMethodVersion ].
	dic at: 'help' put: [ self composeHelpText ].
	dic at: 'revert' put: [ '' ].
	dic at: 'killAll' put: [ debugAPI terminateAllProcesses ].
	^dic
]

{ #category : #actions }
EDEmergencyDebugger >> buildDefaultActionsDescriptions [
	|dic|
	dic := Dictionary new.
	dic at: 'exit/q' put: 'Exit the emergency debugger'.
	dic at: 'help' put: 'Show this help.'.
	dic at: 'retry' put: 'Retry opening a graphical debugger'.
	dic at: '<UP/DOWN ARROWS>' put: 'Move up/down in the stack'.
	dic at: '<RIGHT/LEFT ARROWS>' put: 'Navigate the current method versions'.
	dic at: 'revert' put: 'Revert the current method to the selected method version'.
	dic at: 'killAll' put: 'Terminate all non-essential processes (will terminate Ed)'.
	^dic
]

{ #category : #actions }
EDEmergencyDebugger >> buildDefaultActionsDescriptionsMap [
	|dic|
	dic := Dictionary new.	
	dic at: 'exit' put: 'exit/q'.
	dic at: 'q' put: 'exit/q'.
	dic at: 'retry' put: 'retry'.
	dic at: Character arrowUp put: '<UP/DOWN ARROWS>'.
	dic at: Character arrowDown put: '<UP/DOWN ARROWS>'.
	dic at: Character arrowLeft put: '<RIGHT/LEFT ARROWS>'.
	dic at: Character arrowRight put: '<RIGHT/LEFT ARROWS>'.
	dic at: 'revert' put: 'revert'.
	dic at: 'help' put: 'help'.
	dic at: 'killAll' put: 'killAll'.
	^dic
]

{ #category : #'text - composing' }
EDEmergencyDebugger >> composeDisplayText [
	^(titleText , stackText, methodText, input, result )

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
	| str method node text |
	str := self newTextStream.
	self writeSectionTitle: 'SOURCE' on: str.
	method := debugAPI methodAt: stackSelectionIndex.
	node := debugAPI nodeAt: stackSelectionIndex.	
	text := method sourceCode asText.
	text makeColor: rawDisplay red from: node start to: node stop.
	str << method methodClass name.
	str << '>>'.
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
	stack := self shortStack.
	str cr.
	self
		writeSectionTitle:
			'STACK (' , stackSelectionIndex printString , '/'
				, debugAPI stackSize printString , ')'
		on: str.
	1 to: stack size do: [ :i | 
		| textStream text |
		textStream := self newTextStream.
		(stack at: i) printWithArgsValueOn: textStream.
		text := textStream contents.
		i = shortStackIndex
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
	self basicDebug: aDebugSession.
	self composeTitleText.
	self composeStackText.
	self composeMethodText.
	self composeHelpText.
	self composePromptWith: ''.
	self updateDisplay.
	repl readEvalPrint 
]

{ #category : #'text - helpers' }
EDEmergencyDebugger >> defaultResultText [
	^ 'TYPE h FOR HELP' asText
]

{ #category : #actions }
EDEmergencyDebugger >> descriptionFromPromptCommand: aString [
	|key|
	key := self availableActionsDescriptionsMap at: aString.
	^self availableActionsDescriptions at: key
]

{ #category : #evaluation }
EDEmergencyDebugger >> eval: command [
	self evalCommand: command.
	self composePromptWith: ''.
	self updateDisplay
]

{ #category : #evaluation }
EDEmergencyDebugger >> evalCommand: aString [
	| action |
	action := self availableActions at: aString ifAbsent: [ ^ false ].
	[ action value ]
		on: Exception
		do: [ self
				composeResult:
					('Cannot ' , (self descriptionFromPromptCommand: aString)) asText
						allBold
				title: 'ERROR' ].
	self updateDisplay.
	^ true
]

{ #category : #initialization }
EDEmergencyDebugger >> initialize [
	repl := EDREPLInterface forDebugger: self.
	rawDisplay := EDDisplayInterface new.
	stackSelectionIndex := 1.
	shortStackIndex := 1.
	methodVersionSelectionIndex := 0.
	input := Text new.
	self composeResult: Text new title: self defaultResultText.
	isRunning := false
]

{ #category : #testing }
EDEmergencyDebugger >> isRunning [
	^isRunning 
]

{ #category : #stack }
EDEmergencyDebugger >> moveDownInStack [
	stackSelectionIndex = debugAPI stackSize
		ifTrue: [ ^ self ].
	stackSelectionIndex := stackSelectionIndex + 1.
	shortStackIndex := shortStackIndex + 1.
	shortStackIndex > debugAPI displayStackSize
		ifTrue: [ self shiftDownShortStack ].
	methodVersionSelectionIndex := 0.
	self composeStackText.
	self composeMethodText.
	self composeHelpText
]

{ #category : #stack }
EDEmergencyDebugger >> moveUpInStack [
	stackSelectionIndex = 1
		ifTrue: [ ^ self ].
	stackSelectionIndex := stackSelectionIndex - 1.
	shortStackIndex := shortStackIndex - 1.
	shortStackIndex = 0
		ifTrue: [ self shiftUpShortStack ].
	methodVersionSelectionIndex := 0.
	self composeStackText.
	self composeMethodText.
	self composeHelpText
]

{ #category : #'text - helpers' }
EDEmergencyDebugger >> newTextStream [
	^WriteStream on: Text new
]

{ #category : #evaluation }
EDEmergencyDebugger >> performActionForChar: aCharacter [
	^self evalCommand: aCharacter
]

{ #category : #accessing }
EDEmergencyDebugger >> resultText [
	^ result
]

{ #category : #methods }
EDEmergencyDebugger >> selectedMethodVersion [
	|versions |	
	versions := debugAPI methodVersionAt: stackSelectionIndex.
	^versions at: methodVersionSelectionIndex.
	
]

{ #category : #methods }
EDEmergencyDebugger >> selectedMethodVersionsSize [
	^ debugAPI methodVersionSizeAt: stackSelectionIndex
]

{ #category : #'text - helpers' }
EDEmergencyDebugger >> separator [ 
	^'--------------------' asText makeAllColor: rawDisplay gray
]

{ #category : #stack }
EDEmergencyDebugger >> shiftDownShortStack [
	"rebuilds the short stack that is displayed by shitfing down the stack view by debugAPI displayStackSize elements"

	| start stop |
	shortStackIndex := 1.
	start := stackSelectionIndex.
	stop := stackSelectionIndex + debugAPI displayStackSize - 1
		min: debugAPI stackSize.
	shortStack := debugAPI stackFrom: start to: stop
]

{ #category : #stack }
EDEmergencyDebugger >> shiftUpShortStack [
	"rebuilds the short stack that is displayed by shitfing up the stack view by debugAPI displayStackSize elements"

	stackSelectionIndex = 1
		ifTrue: [ ^ shortStack := debugAPI stackFrom: 1 to: debugAPI displayStackSize ].
	shortStackIndex := debugAPI displayStackSize.
	^ shortStack := debugAPI
		stackFrom: (stackSelectionIndex - debugAPI displayStackSize max: 1)
		to: stackSelectionIndex
]

{ #category : #stack }
EDEmergencyDebugger >> shortStack [
	^ shortStack
		ifNil: [ shortStack := debugAPI stackFrom: 1 to: debugAPI displayStackSize ]
]

{ #category : #methods }
EDEmergencyDebugger >> showMoreRecentMethodVersion [
	methodVersionSelectionIndex := methodVersionSelectionIndex - 1 max: 1.
	self showSelectedMethodVersion
]

{ #category : #methods }
EDEmergencyDebugger >> showOlderMethodVersion [
	methodVersionSelectionIndex := methodVersionSelectionIndex + 1
		min: self selectedMethodVersionsSize.
	self showSelectedMethodVersion
]

{ #category : #methods }
EDEmergencyDebugger >> showSelectedMethodVersion [
	| selectedVersion text |
	selectedVersion := self selectedMethodVersion.
	text := selectedVersion sourceCode asText.
	text makeBoldFrom: 1 to: selectedVersion selector size.
	self
		composeResult: text
		title:
			'VERSIONS (' , methodVersionSelectionIndex printString , '/'
				, self selectedMethodVersionsSize printString , ')'.
	self updateDisplay
]

{ #category : #initialization }
EDEmergencyDebugger >> terminate [
	isRunning := false
]

{ #category : #updating }
EDEmergencyDebugger >> updateDisplay [
	rawDisplay clear.
	rawDisplay show: self composeDisplayText 

]

{ #category : #updating }
EDEmergencyDebugger >> updatePrompt: aString [
	self composePromptWith: aString.
	self updateDisplay
]

{ #category : #'text - helpers' }
EDEmergencyDebugger >> writeSectionTitle: aString on: aStream [
	self writeSeparatorOn: aStream.
	aStream << (aString asText makeAllColor: rawDisplay gray).
	aStream cr.
	self writeSeparatorOn: aStream
]

{ #category : #'text - helpers' }
EDEmergencyDebugger >> writeSeparatorOn: aStream [
	aStream << self separator.
	aStream cr
]
