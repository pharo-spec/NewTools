Class {
	#name : 'StContextPrinter',
	#superclass : 'Object',
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'printing' }
StContextPrinter class >> printContext: aContext [

	^ String streamContents: [ :stream |
		  self printPackage: aContext method package on: stream.
		  self printReceiverClassInContext: aContext on: stream.
		  self printMethod: aContext method on: stream ]
]

{ #category : 'printing' }
StContextPrinter class >> printMethod: aCompiledMethod on: aStream [
	aStream << '>>'.
	aStream << (aCompiledMethod isCompiledBlock
		ifTrue: [ aCompiledMethod sourceNode sourceCode ]
		ifFalse: [ aCompiledMethod selector ])
]

{ #category : 'printing' }
StContextPrinter class >> printPackage: aPackage on: aStream [

	aPackage ifNil: [ ^ self ].
	aStream << '['.
	aStream << aPackage name asString.
	aStream << ']'.
	aStream space
]

{ #category : 'printing' }
StContextPrinter class >> printReceiverClassInContext: aContext on: aStream [

	| receiverClass methodClass |
	receiverClass := aContext receiver class.
	methodClass := aContext method methodClass.
	aStream << receiverClass name.
	receiverClass == methodClass ifTrue: [ ^ self ].
	aStream space.
	aStream << '('.
	aStream << methodClass name.
	aStream << ')'
]
