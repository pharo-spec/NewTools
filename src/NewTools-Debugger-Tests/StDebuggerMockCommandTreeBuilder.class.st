Class {
	#name : #StDebuggerMockCommandTreeBuilder,
	#superclass : #StDebuggerCommandTreeBuilder,
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #accessing }
StDebuggerMockCommandTreeBuilder class >> displayStrategy [
	^CmUIDisplayAsSubMenu
]

{ #category : #accessing }
StDebuggerMockCommandTreeBuilder class >> groupDescription [
	^'mock group'
]

{ #category : #accessing }
StDebuggerMockCommandTreeBuilder class >> groupName [
	^'mock'
]

{ #category : #building }
StDebuggerMockCommandTreeBuilder >> buildDebuggerCommandGroup [
	
]
