Class {
	#name : #CreateSubclassResponsabilityDebugCommand,
	#superclass : #DebugCommand,
	#category : #'Debugger-Commands'
}

{ #category : #accessing }
CreateSubclassResponsabilityDebugCommand class >> defaultCommandName [
	<toolbarDebugCommand: 10>
	^ 'Create'
]

{ #category : #accessing }
CreateSubclassResponsabilityDebugCommand class >> defaultDescription [
	^ 'Create a method in a class having the responsability to implement it.'
]

{ #category : #initialization }
CreateSubclassResponsabilityDebugCommand class >> defaultIconName [
	^ #changeAdd
]

{ #category : #initialization }
CreateSubclassResponsabilityDebugCommand class >> defaultShortcut [
	^ nil
]

{ #category : #testing }
CreateSubclassResponsabilityDebugCommand >> appliesToDebugger: aDebugger [
	| interruptedContext |
	
	interruptedContext := aDebugger session interruptedContext.
	^ (interruptedContext selector == #subclassResponsibility) and: [ 
		"If we work with an instance of the abstract class (shouldn't normally happen) do not add this action, 
		as the abstract class alredy contains the the method."
		interruptedContext sender receiver class ~~ interruptedContext sender methodClass  ]


]

{ #category : #private }
CreateSubclassResponsabilityDebugCommand >> askForSuperclassOf: aClass to: aSuperclass toImplement: aSelector ifCancel: cancelBlock [
	| classes currentSuperclass chosenClassIndex |
	
	classes := OrderedCollection new.
	classes add: aClass.
	currentSuperclass := aClass superclass.
	[ currentSuperclass == nil or: [ currentSuperclass == aSuperclass ] ]
		whileFalse: [
			classes add: currentSuperclass.
			currentSuperclass := currentSuperclass superclass ].
	classes := classes addAll: (aClass traits sort: [ :t1 :t2 | t1 asString < t2 asString ]); yourself.
	
	classes size = 1 ifTrue: [ ^ classes at: 1 ].
	chosenClassIndex := UIManager default 
		chooseFrom: (classes collect: [:c | c name])
		title: 'Define #', aSelector, ' in which class?'.
	chosenClassIndex = 0 ifTrue: [^ cancelBlock value].
	^ classes at: chosenClassIndex
]

{ #category : #actions }
CreateSubclassResponsabilityDebugCommand >> execute [
	| senderContext msg msgCategory chosenClass |
	self flag: 'broken'.
	senderContext := self interruptedContext sender.
	msg := Message 
		selector: senderContext selector
		arguments: senderContext arguments.
	msgCategory := senderContext methodClass organization categoryOfElement: msg selector.
	
	chosenClass := self 
		askForSuperclassOf: senderContext receiver class 
		to: senderContext methodClass 
		toImplement: senderContext selector 
		ifCancel: [ ^ self ].

	self session 
		implement: msg 
		classified: msgCategory 
		inClass: chosenClass 
		forContext: senderContext.
]
