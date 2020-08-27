"
Special node to display context temprs and arguments in the debugger inspector
"
Class {
	#name : #StDebuggerInspectorTempNode,
	#superclass : #StInspectorTempNode,
	#instVars : [
		'label'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #comparing }
StDebuggerInspectorTempNode >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ tempVariable = anObject tempVariable and: [ 
		  hostObject = anObject hostObject1 and: [ label = anObject label ] ]
]

{ #category : #accessing }
StDebuggerInspectorTempNode >> argVariable: aVariable [

	super tempVariable: aVariable.
	label := '[arg] ' , tempVariable name
]

{ #category : #accessing }
StDebuggerInspectorTempNode >> children [
	^ #()
]

{ #category : #accessing }
StDebuggerInspectorTempNode >> computeChildrenFromSourceObject [
	^ self value allInspectorNodes reject: [ :node | node key = 'self' ]
]

{ #category : #comparing }
StDebuggerInspectorTempNode >> hash [

	"Answer an integer value that is related to the identity of the receiver."

	^ tempVariable hash bitXor: (hostObject hash bitXor: label hash)
]

{ #category : #accessing }
StDebuggerInspectorTempNode >> hostObject1 [
	^ hostObject
]

{ #category : #accessing }
StDebuggerInspectorTempNode >> label [
	^label
]

{ #category : #accessing }
StDebuggerInspectorTempNode >> tempVariable [
	^ tempVariable
]

{ #category : #accessing }
StDebuggerInspectorTempNode >> tempVariable: aVariable [

	super tempVariable: aVariable.
	label := '[temp] ' , tempVariable name
]
