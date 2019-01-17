Class {
	#name : #StInspectorContextIndexedTempNode,
	#superclass : #StInspectorNode,
	#instVars : [
		'tempIndex'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'as yet unclassified' }
StInspectorContextIndexedTempNode class >> hostObject: aContext tempIndex: anInteger [
	^ (self hostObject: aContext) 
		tempIndex: anInteger;
		yourself
]

{ #category : #accessing }
StInspectorContextIndexedTempNode >> label [
	^ self tempIndex
]

{ #category : #accessing }
StInspectorContextIndexedTempNode >> rawValue [
	^ self hostObject at: self tempIndex
]

{ #category : #accessing }
StInspectorContextIndexedTempNode >> tempIndex [
	^ tempIndex
]

{ #category : #accessing }
StInspectorContextIndexedTempNode >> tempIndex: anObject [
	tempIndex := anObject
]

{ #category : #accessing }
StInspectorContextIndexedTempNode >> variableTag [
	^  'temp' 
]
