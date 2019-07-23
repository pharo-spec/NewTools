Class {
	#name : #DebugCommand,
	#superclass : #CmCommand,
	#category : #'Debugger-Commands'
}

{ #category : #initialization }
DebugCommand class >> defaultIconName [
	^ self subclassResponsibility
]

{ #category : #initialization }
DebugCommand class >> defaultShortcut [
	^ self subclassResponsibility
]

{ #category : #testing }
DebugCommand >> appliesToDebugger: aDebugger [
	^ true
]

{ #category : #accessing }
DebugCommand >> currentContext [
	^self debugger context
]

{ #category : #accessing }
DebugCommand >> debugger [
	^self context
]

{ #category : #initialization }
DebugCommand >> initialize [
	super initialize.
	"self
		basicName: self debugCommandName;
		basicDescription: self debugCommandDescription. "
]

{ #category : #accessing }
DebugCommand >> session [
	^self debugger session
]
