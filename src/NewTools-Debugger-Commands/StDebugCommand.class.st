"
I command actions that can be requested from a debugger
"
Class {
	#name : #StDebugCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Debugger-Commands'
}

{ #category : #'instance creation' }
StDebugCommand class >> codeContextMenuCommandsForDebugger: debugger [

	^ self
		instantiateCommandsFromPragma: #CodeContextMenuDebugCommand
		for: debugger
]

{ #category : #initialization }
StDebugCommand class >> defaultIconName [
	^ self subclassResponsibility
]

{ #category : #initialization }
StDebugCommand class >> defaultShortcut [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
StDebugCommand class >> forSpecContext: anObject [
	^ (self
		forSpecWithIconNamed: self defaultIconName
		shortcutKey: self defaultShortcut)
		context: anObject;
		yourself
]

{ #category : #default }
StDebugCommand class >> shortName [
	^self defaultName
]

{ #category : #'instance creation' }
StDebugCommand class >> toolbarCommandsForDebugger: debugger [

	^ self
		instantiateCommandsFromPragma: #toolbarDebugCommand:
		for: debugger
]

{ #category : #comparing }
StDebugCommand >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ context = anObject context
		and: [ basicName = anObject name ]
]

{ #category : #testing }
StDebugCommand >> appliesTo: aDebugger [
	^ aDebugger session isInterruptedContextDoesNotUnderstand not
]

{ #category : #accessing }
StDebugCommand >> canBeExecuted [
	^ self appliesTo: self debugger
]

{ #category : #accessing }
StDebugCommand >> debugger [
	^self context
]

{ #category : #comparing }
StDebugCommand >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ context hash bitXor: basicName hash
]

{ #category : #initialization }
StDebugCommand >> initialize [

	super initialize.
	self description: (String streamContents: [ :stream | 
		stream 
			<< self class defaultName
			<< ': '
			<< self class defaultDescription ])
]

{ #category : #accessing }
StDebugCommand >> session [
	^self debugger session
]
