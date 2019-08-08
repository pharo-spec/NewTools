Class {
	#name : #DebugCommand,
	#superclass : #CmCommand,
	#classVars : [
		'AnonymousCommands'
	],
	#category : #'Debugger-Commands'
}

{ #category : #'instance creation' }
DebugCommand class >> addAnonymousCommand: aCommand [
	AnonymousCommands ifNil:[AnonymousCommands := OrderedCollection new].
	AnonymousCommands add: aCommand
]

{ #category : #'instance creation' }
DebugCommand class >> codeContextMenuCommandsForDebugger: debugger [
	^ self
		instantiateCommands: (self debugCommandClassesForPragma: #CodeContextMenuDebugCommand)
		forDebugger: debugger
]

{ #category : #accessing }
DebugCommand class >> debugCommandClassesForPragma: aSymbol [
	| allClasses commandsClasses |
	allClasses := OrderedCollection withAll: self allSubclasses.
	allClasses addAll: AnonymousCommands.
	commandsClasses := OrderedCollection new.
	(allClasses reject: [ :sc | sc hasAbstractMethods ])
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
DebugCommand class >> newAnonymousActionLabeled: title icon: icon executeScript: sourceCode [

	|command|
	command := self newAnonymousSubclass.
	command compile: 'execute ', sourceCode.
	command class compile: 'defaultCommandName
	<toolbarDebugCommand: 9999>
	^', title printString.
	command class compile: 'defaultIconName
	^#', icon.
	command class compile: 'defaultShortcut
	^ nil'.
	self addAnonymousCommand: command.
	^command
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
