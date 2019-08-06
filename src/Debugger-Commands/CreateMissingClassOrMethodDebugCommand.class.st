Class {
	#name : #CreateMissingClassOrMethodDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #accessing }
CreateMissingClassOrMethodDebugCommand class >> defaultCommandName [
	<toolbarDebugCommand: 0>
	^ 'Create'
]

{ #category : #accessing }
CreateMissingClassOrMethodDebugCommand class >> defaultDescription [
    ^ 'Create the missing class or method in the user prompted class, and restart the debugger at the location where it can be edited.'
]

{ #category : #initialization }
CreateMissingClassOrMethodDebugCommand class >> defaultIconName [
	^ #changeAdd
]

{ #category : #initialization }
CreateMissingClassOrMethodDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #testing }
CreateMissingClassOrMethodDebugCommand >> appliesToDebugger: aDebugger [

	^ aDebugger session isInterruptedContextDoesNotUnderstand 
]

{ #category : #private }
CreateMissingClassOrMethodDebugCommand >> askForCategoryIn: aClass default: aString [
	| categoryName |
	categoryName := AbstractTool requestProtocolNameFor: aClass initialAnswer: aString.
	categoryName ifNil: [^aString].
	^ categoryName isEmptyOrNil 
		ifTrue: [^ aString] 
		ifFalse: [ categoryName ]
]

{ #category : #private }
CreateMissingClassOrMethodDebugCommand >> askForSuperclassOf: aClass toImplement: aSelector ifCancel: cancelBlock [
	| classes chosenClassIndex |
	classes := aClass withAllSuperclasses addAll: (aClass traits sort: [ :t1 :t2 | t1 asString < t2 asString ]); yourself.
	chosenClassIndex := UIManager default 
		chooseFrom: (classes collect: [:c | c name])
		title: 'Define #', aSelector, ' in which class?'.
	chosenClassIndex = 0 ifTrue: [^ cancelBlock value].
	^ classes at: chosenClassIndex
]

{ #category : #private }
CreateMissingClassOrMethodDebugCommand >> createMissingClassWith: variableNode in: aContext [
	|  previousContext  |
		
	OCUndeclaredVariableWarning new
		node: variableNode;
		defineClass: variableNode name.
		
	previousContext := aContext sender.
	
	self closeWindow.
	
	previousContext restart
]

{ #category : #hooks }
CreateMissingClassOrMethodDebugCommand >> execute [
	"Should only be called when the debugger was created in response to a
	MessageNotUnderstood exception. Create a stub for the method that was
	missing and proceed into it, or create a class if it was missing instead"
	
	| msg msgCategory chosenClass exception |
	self flag: 'broken'.
	msg := self interruptedContext tempAt: 1.
	exception := self interruptedContext tempAt: 2.
	
	(exception class == VariableNotDeclared) ifTrue: [ 
		self createMissingClassWith: exception variableNode in: self interruptedContext ].
	
	chosenClass := self 
		askForSuperclassOf: self interruptedContext receiver class
		toImplement: msg selector
		ifCancel: [^self].
	msgCategory := (self askForCategoryIn: chosenClass default: 'as yet unclassified').
	self  session
		implement: msg 
		classified: msgCategory 
		inClass: chosenClass 
		forContext: self interruptedContext.
	self debugger selectTopContext
]
