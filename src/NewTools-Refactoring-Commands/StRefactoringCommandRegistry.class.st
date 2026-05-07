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
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'public-api' }
StRefactoringCommandRegistry class >> commands [

	Commands ifNil: [ Commands := SortedCollection sortBlock: [ :a :b | a priority < b priority ] ].
	^ Commands
]

{ #category : 'actions' }
StRefactoringCommandRegistry class >> registerCommand: aCommandClass [

	self commands add: aCommandClass
]

{ #category : 'class initialization' }
StRefactoringCommandRegistry class >> reset [

	<script>
	self initialize
]
