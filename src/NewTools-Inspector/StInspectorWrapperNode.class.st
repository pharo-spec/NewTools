Class {
	#name : #StInspectorWrapperNode,
	#superclass : #StInspectorNode,
	#instVars : [
		'label'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'instance creation' }
StInspectorWrapperNode class >> hostObject: anObject label: aString [
	^ (self hostObject: anObject) 
		label: aString;
		yourself
]

{ #category : #composition }
StInspectorWrapperNode >> childrenNodesFor: aVariablesBrowser [
	^ self hostObject childrenNodesFor: aVariablesBrowser
]

{ #category : #accessing }
StInspectorWrapperNode >> errorMessage [
	^ self hostObject errorMessage
]

{ #category : #accessing }
StInspectorWrapperNode >> inspectorActionsForNode [
	^ self hostObject inspectorActionsForNode
]

{ #category : #accessing }
StInspectorWrapperNode >> key [
	^ label ifNil: [ self hostObject key ]
]

{ #category : #accessing }
StInspectorWrapperNode >> label: aString [
	label := aString
]

{ #category : #accessing }
StInspectorWrapperNode >> rawValue [
	^ self hostObject rawValue
]

{ #category : #accessing }
StInspectorWrapperNode >> variableTag [
	^ self hostObject variableTag
]
