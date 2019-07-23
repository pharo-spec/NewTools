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
			commandsClasses
				addAll:
					((Pragma
						allNamed: aSymbol
						from: commandClass class
						to: commandClass class)
						collect: [ :pragma | pragma methodClass soleInstance ]) ].
	^ commandsClasses
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
		instantiateCommands: (self debugCommandClassesForPragma: #ToolbarDebugCommand)
		forDebugger: debugger
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
