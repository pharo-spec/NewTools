Class {
	#name : #DebugCommand,
	#superclass : #CmCommand,
	#category : #'Debugger-Commands'
}

{ #category : #'instance creation' }
DebugCommand class >> codeContextMenuCommandsForDebugger: debugger [

	^ self
		instantiateCommandsFromPragma: #CodeContextMenuDebugCommand
		for: debugger
]

{ #category : #initialization }
DebugCommand class >> defaultIconName [
	^ self subclassResponsibility
]

{ #category : #initialization }
DebugCommand class >> defaultShortcut [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
DebugCommand class >> forSpecContext: anObject [
	^ (self
		forSpecWithIconNamed: self defaultIconName
		shortcutKey: self defaultShortcut)
		context: anObject;
		yourself
]

{ #category : #'instance creation' }
DebugCommand class >> preDebugCommandsForDebugger: debugger [
	
	^ self
		instantiateCommandsFromPragma: #PreDebugCommand
		for: debugger
]

{ #category : #'instance creation' }
DebugCommand class >> stackContextMenuCommandsForDebugger: debugger [
	
	^ self
		instantiateCommandsFromPragma: #StackContextMenuDebugCommand
		for: debugger
]

{ #category : #'instance creation' }
DebugCommand class >> toolbarCommandsForDebugger: debugger [

	^ self
		instantiateCommandsFromPragma: #toolbarDebugCommand:
		for: debugger
]

{ #category : #testing }
DebugCommand >> appliesTo: aDebugger [

	^ self appliesToDebugger: aDebugger
]

{ #category : #testing }
DebugCommand >> appliesToDebugger: aDebugger [

	^ true
]

{ #category : #accessing }
DebugCommand >> currentContext [

	^ self debugger currentContext
]

{ #category : #accessing }
DebugCommand >> debugger [
	^self context
]

{ #category : #initialization }
DebugCommand >> initialize [

	super initialize.
	self description: (String streamContents: [ :stream | 
		stream 
			<< self class defaultName
			<< ': '
			<< self class defaultDescription ])
]

{ #category : #hooks }
DebugCommand >> interruptedContext [
	^ self debugger interruptedContext
]

{ #category : #accessing }
DebugCommand >> session [
	^self debugger session
]
