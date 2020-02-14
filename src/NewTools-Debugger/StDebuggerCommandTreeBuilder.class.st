"
I am an abstract class which provides interfaces for building a tree of commands for the StDebugger.
I set the debugger instance and the root command group on which the tree is going to be built, and instantiation interface on class side.
My subclasses must implement buildDebugerCommandGroup in which they build their particular subgroup of commands.
My subclasses know how to inject their subgroup into the main command tree.  
"
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
