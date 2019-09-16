Class {
	#name : #DebugCommand,
	#superclass : #CmCommand,
	#category : #'Debugger-Commands'
}

{ #category : #'instance creation' }
DebugCommand class >> codeContextMenuCommandsForDebugger: debugger [
	^ self
		instantiateCommands: (self debugCommandClassesForPragma: #CodeContextMenuDebugCommand)
		forDebugger: debugger
]

{ #category : #accessing }
DebugCommand class >> debugCommandClassesForPragma: aSymbol [
	| commandsClasses |
	
	commandsClasses := OrderedCollection new.
	(self allSubclasses reject: [ :sc | sc hasAbstractMethods ])
		do: [ :commandClass | 
			commandsClasses addAll: (Pragma
				allNamed: aSymbol
				from: commandClass class
				to: commandClass class) ].
	
	^ ((aSymbol last = $:)
		ifTrue: [ commandsClasses sorted: [ :a :b | (a argumentAt: 1) < (b argumentAt: 1) ] ]
		ifFalse: [ commandsClasses ])
		collect: [ :pragma | pragma methodClass soleInstance ]
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
DebugCommand class >> instantiateCommands: commandClasses forDebugger: debugger [
	^ commandClasses
		collect: [ :commandClass | commandClass forSpecContext: debugger ]
		thenSelect: [ :debugCommand | debugCommand decoratedCommand appliesToDebugger: debugger ]
]

{ #category : #'instance creation' }
DebugCommand class >> preDebugCommandsForDebugger: debugger [
	^ self
		instantiateCommands: (self debugCommandClassesForPragma: #PreDebugCommand)
		forDebugger: debugger
]

{ #category : #'instance creation' }
DebugCommand class >> stackContextMenuCommandsForDebugger: debugger [
	^ self
		instantiateCommands: (self debugCommandClassesForPragma: #StackContextMenuDebugCommand)
		forDebugger: debugger
]

{ #category : #'instance creation' }
DebugCommand class >> toolbarCommandsForDebugger: debugger [
	^ self
		instantiateCommands: (self debugCommandClassesForPragma: #toolbarDebugCommand:)
		forDebugger: debugger
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
