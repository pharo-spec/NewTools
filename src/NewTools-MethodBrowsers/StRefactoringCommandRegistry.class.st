"
I represent a registry for refactoring commands.

These commands are sorted by priority
"
Class {
	#name : 'StRefactoringCommandRegistry',
	#superclass : 'Object',
	#classVars : [
		'Commands'
	],
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
}

{ #category : 'public-api' }
StRefactoringCommandRegistry class >> commands [

	^ Commands 
]

{ #category : 'class initialization' }
StRefactoringCommandRegistry class >> initialize [

	Commands := SortedCollection sortBlock: [ :a :b | a priority < b priority ]
]

{ #category : 'actions' }
StRefactoringCommandRegistry class >> registerCommand: aCommandClass [

	Commands ifNil: [ self initialize ].
	Commands add: aCommandClass
]

{ #category : 'class initialization' }
StRefactoringCommandRegistry class >> reset [

	<script>
	self initialize
]
