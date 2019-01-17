Class {
	#name : #StInspectorIndexedNode,
	#superclass : #StInspectorNode,
	#instVars : [
		'index'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'instance creation' }
StInspectorIndexedNode class >> hostObject: anObject index: index [
	^ (self hostObject: anObject)
		index: index;
		yourself
]

{ #category : #accessing }
StInspectorIndexedNode >> errorMessage [
	^ 'error obtaining indexed attribute value'
]

{ #category : #accessing }
StInspectorIndexedNode >> index [
	^ index
]

{ #category : #accessing }
StInspectorIndexedNode >> index: anInteger [
	index := anInteger
]

{ #category : #accessing }
StInspectorIndexedNode >> key [
	^ self index
]

{ #category : #accessing }
StInspectorIndexedNode >> rawValue [
	^ self hostObject basicAt: index
]

{ #category : #actions }
StInspectorIndexedNode >> save: aValue [
	self hostObject at: self index put: aValue
]

{ #category : #accessing }
StInspectorIndexedNode >> variableTag [
	^ 'attribute'
]
