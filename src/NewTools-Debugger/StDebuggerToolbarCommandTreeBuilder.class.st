Class {
	#name : #StDebuggerToolbarCommandTreeBuilder,
	#superclass : #StDebuggerCommandTreeBuilder,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerToolbarCommandTreeBuilder class >> commandDisplayStrategy [
	^CmUIDisplayAsGroup
]

{ #category : #accessing }
StDebuggerToolbarCommandTreeBuilder class >> groupDescription [
	^ 'Debug actions.'
]

{ #category : #accessing }
StDebuggerToolbarCommandTreeBuilder class >> groupName [ 	
	^'Toolbar'
]
