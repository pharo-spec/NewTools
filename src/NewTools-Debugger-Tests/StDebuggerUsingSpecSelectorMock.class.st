Class {
	#name : #StDebuggerUsingSpecSelectorMock,
	#superclass : #StDebuggerUsingSpecSelector,
	#instVars : [
		'withDebuggerExtensions',
		'withActivatedExtensions'
	],
	#category : #'NewTools-Debugger-Tests-Debugger - model'
}

{ #category : #initialization }
StDebuggerUsingSpecSelectorMock class >> initializeExtensionsActivated [
	^self new initializeExtensionsActivated
]

{ #category : #initialization }
StDebuggerUsingSpecSelectorMock class >> initializeExtensionsNoneActivated [
	^self new initializeExtensionsNoneActivated
]

{ #category : #initialization }
StDebuggerUsingSpecSelectorMock class >> initializeNoExtensionsActivated [
	^self new initializeNoExtensionsActivated
]

{ #category : #initialization }
StDebuggerUsingSpecSelectorMock class >> initializeNoExtensionsNoneActivated [
	^self new initializeNoExtensionsNoneActivated
]

{ #category : #accessing }
StDebuggerUsingSpecSelectorMock >> activateDebuggerExtensions [
	^withDebuggerExtensions 
]

{ #category : #specs }
StDebuggerUsingSpecSelectorMock >> columnInspectorsSpec [
]

{ #category : #accessing }
StDebuggerUsingSpecSelectorMock >> debuggerClass [ 	
	^self
]

{ #category : #accessing }
StDebuggerUsingSpecSelectorMock >> hasAnyActivatedExtension [
	^ withActivatedExtensions
]

{ #category : #initialization }
StDebuggerUsingSpecSelectorMock >> initializeExtensionsActivated [
	withDebuggerExtensions := true.
	withActivatedExtensions := true
]

{ #category : #initialization }
StDebuggerUsingSpecSelectorMock >> initializeExtensionsNoneActivated [
	withDebuggerExtensions := true.
	withActivatedExtensions := false
]

{ #category : #initialization }
StDebuggerUsingSpecSelectorMock >> initializeNoExtensionsActivated [
	withDebuggerExtensions := false.
	withActivatedExtensions := true
]

{ #category : #initialization }
StDebuggerUsingSpecSelectorMock >> initializeNoExtensionsNoneActivated [
	withDebuggerExtensions := false.
	withActivatedExtensions := false
]
