"
I am a fake debugger to allow the testing of Sindarin debugger commands without side effects on a StDebugger instance. 
"
Class {
	#name : 'SindarinTestCommandDebugger',
	#superclass : 'Object',
	#instVars : [
		'session',
		'tag',
		'debuggerActionModel'
	],
	#category : 'NewTools-Sindarin-Commands-Tests',
	#package : 'NewTools-Sindarin-Commands-Tests'
}

{ #category : 'accessing' }
SindarinTestCommandDebugger >> debuggerActionModel [
	^ debuggerActionModel ifNil: [ debuggerActionModel := StDebuggerActionModel on: self session ]
]

{ #category : 'removing' }
SindarinTestCommandDebugger >> forceSessionUpdate [ 
	tag := #forceSessionUpdate
]

{ #category : 'removing' }
SindarinTestCommandDebugger >> removeSessionHolderSubscriptions [ 
	tag := #removeSessionHolderSubscriptions
]

{ #category : 'accessing' }
SindarinTestCommandDebugger >> session [

	^ session
]

{ #category : 'accessing' }
SindarinTestCommandDebugger >> session: anObject [

	session := anObject.
	session ifNotNil: [ self debuggerActionModel session: anObject ]
]

{ #category : 'removing' }
SindarinTestCommandDebugger >> setSessionHolderSubscriptions [ 
	tag := #setSessionHolderSubscriptions
]

{ #category : 'removing' }
SindarinTestCommandDebugger >> sindarinDebugger [
	^ SindarinDebugger attachTo: session
]

{ #category : 'removing' }
SindarinTestCommandDebugger >> toolbar [

	^ self
]

{ #category : 'gui' }
SindarinTestCommandDebugger >> warning: aString for: aSindarinTestCommandDebugger [

	^ self
]
