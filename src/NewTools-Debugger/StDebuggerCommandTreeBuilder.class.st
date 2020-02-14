Class {
	#name : #StDebuggerCommandTreeBuilder,
	#superclass : #Object,
	#instVars : [
		'rootCommandGroup',
		'stDebuggerInstance'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #commands }
StDebuggerCommandTreeBuilder class >> buildCommandsGroupWith: aStDebuggerInstance forRoot: aRootCommandGroup [
	^self new buildCommandsGroupWith: aStDebuggerInstance forRoot: aRootCommandGroup
]

{ #category : #commands }
StDebuggerCommandTreeBuilder >> buildCommandsGroupWith: aStDebuggerInstance forRoot: aRootCommandGroup [
	stDebuggerInstance := aStDebuggerInstance.
	rootCommandGroup := aRootCommandGroup.
	self buildDebuggerCommandGroup
]

{ #category : #commands }
StDebuggerCommandTreeBuilder >> buildDebuggerCommandGroup [
	self subclassResponsibility 
]
