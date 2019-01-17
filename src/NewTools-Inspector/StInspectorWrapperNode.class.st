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

{ #category : #accessing }
StInspectorWrapperNode >> errorMessage [
	^ self hostObject errorMessage
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
