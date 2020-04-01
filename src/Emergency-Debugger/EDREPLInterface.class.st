Class {
	#name : #EDREPLInterface,
	#superclass : #ReadWriteStream,
	#instVars : [
		'debugger'
	],
	#category : #'Emergency-Debugger'
}

{ #category : #'instance creation' }
EDREPLInterface class >> forDebugger: aSindarinDebugger [
	^ (self on: (String new: 100))
		debugger: aSindarinDebugger;
		yourself
]

{ #category : #'as yet unclassified' }
EDREPLInterface >> charIsBackspace: aChar [ 
	^aChar = Character backspace
	
]

{ #category : #'as yet unclassified' }
EDREPLInterface >> charIsCR: aChar [ 
	^aChar = Character cr
	
]

{ #category : #accessing }
EDREPLInterface >> debugger: anObject [
	debugger := anObject
]

{ #category : #'as yet unclassified' }
EDREPLInterface >> getChar [
	
]

{ #category : #'command line' }
EDREPLInterface >> readEvalPrint [
	Sensor flushKeyboard.
	[ debugger isRunning ]
		whileTrue: [ debugger eval: (self request: '> ').
			self on: (String new: 100) ]
]

{ #category : #'command line' }
EDREPLInterface >> request: prompt [
	| startPos char contents |
	startPos := position.
	Sensor flushKeyboard.
	[ (char := Transcripter nextChar) = Character cr ]
		whileFalse: [ 
			char = Character arrowUp  ifTrue:[debugger moveUpInStack; updateDisplay].
			char = Character arrowDown ifTrue:[debugger moveDownInStack; updateDisplay].
			char = Character backspace
				ifTrue: [ readLimit := position := position - 1 max: startPos ]
				ifFalse: [ self nextPut: char ].
			debugger updatePrompt: self contents. ].
	contents := self contents.	
	^ contents copyFrom: startPos + 1 to: contents size
]
