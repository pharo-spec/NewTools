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

{ #category : #accessing }
StDebuggerCommandTreeBuilder class >> groupDescription [
	^self subclassResponsibility 
]

{ #category : #accessing }
StDebuggerCommandTreeBuilder class >> groupName [
	^self subclassResponsibility 
]

{ #category : #converting }
StDebuggerCommandTreeBuilder >> asMenuPresenter [ 	
	^rootCommandGroup asMenuPresenter
]

{ #category : #building }
StDebuggerCommandTreeBuilder >> buildAndRegisterGroup [
	"builds the group that will register under the provided root command group"

	| group |
	group := (CmCommandGroup named: self groupName) asSpecGroup.
	group description: self groupDescription.
	rootCommandGroup register: group.
	^ group
]

{ #category : #building }
StDebuggerCommandTreeBuilder >> buildCommandsGroupWith: aStDebuggerInstance forRoot: aRootCommandGroup [
	stDebuggerInstance := aStDebuggerInstance.
	rootCommandGroup := aRootCommandGroup.
	self buildDebuggerCommandGroup
]

{ #category : #building }
StDebuggerCommandTreeBuilder >> buildDebuggerCommandGroup [
	self subclassResponsibility 
]

{ #category : #accessing }
StDebuggerCommandTreeBuilder >> group [
	^ rootCommandGroup
		commandOrGroupNamed: self groupName
		ifNone: [ self buildAndRegisterGroup ]
]

{ #category : #accessing }
StDebuggerCommandTreeBuilder >> groupDescription [
	^self class groupDescription
]

{ #category : #accessing }
StDebuggerCommandTreeBuilder >> groupName [ 
	^self class groupName
]
