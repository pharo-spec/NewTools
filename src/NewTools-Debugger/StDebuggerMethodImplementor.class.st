"
I am a simple worker object to support test and debugger driven development. 
I use a `MessageNotUnderstood`or a `SubclassResponsibility` exception to automatically create a missing method.
"
Class {
	#name : 'StDebuggerMethodImplementor',
	#superclass : 'Object',
	#instVars : [
		'session',
		'protocol',
		'targetClassOrTrait'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StDebuggerMethodImplementor class >> forSession: aDebugSession [
	^self new session: aDebugSession 
]

{ #category : 'private - method creation' }
StDebuggerMethodImplementor >> autoClassifyMethod: aMethod [
	self deprecated: 'This is normally done when implementing a message in the debug session code.'.
	aMethod isClassified ifFalse: [ MethodClassifier classify: aMethod ]
]

{ #category : 'accessing - debugger model' }
StDebuggerMethodImplementor >> contextForSelector: aSelector [

	| signalingContext |
	signalingContext := self interruptedContext.
	[ signalingContext selector = aSelector ] whileFalse: [
		signalingContext := signalingContext sender ].
	^ signalingContext sender
]

{ #category : 'accessing - debugger model' }
StDebuggerMethodImplementor >> exception [
	^session exception
]

{ #category : 'method - creation' }
StDebuggerMethodImplementor >> implementMissingMethod [

	| context method |
	context := self targetContext.
	method := session
		          implement: (self exception messageToImplementInContext: context)
		          inClass: (targetClassOrTrait ifNil: [context receiver class])
		          forContext: context.
	protocol ifNotNil: [ method protocol: protocol ].
	^ method
]

{ #category : 'accessing - debugger model' }
StDebuggerMethodImplementor >> interruptedContext [

	^ session interruptedContext
]

{ #category : 'accessing' }
StDebuggerMethodImplementor >> protocol [

	^ protocol
]

{ #category : 'accessing' }
StDebuggerMethodImplementor >> protocol: anObject [

	protocol := anObject
]

{ #category : 'accessing' }
StDebuggerMethodImplementor >> session: anObject [

	session := anObject
]

{ #category : 'accessing - debugger model' }
StDebuggerMethodImplementor >> targetClassOrTrait [
	^targetClassOrTrait ifNil:[self exception classForMethodCreation] 
]

{ #category : 'accessing - debugger model' }
StDebuggerMethodImplementor >> targetContext [

	^ self exception contextForMethodCreationFrom: self
]
