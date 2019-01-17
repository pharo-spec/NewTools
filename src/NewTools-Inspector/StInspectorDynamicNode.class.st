Class {
	#name : #StInspectorDynamicNode,
	#superclass : #StInspectorNode,
	#instVars : [
		'label',
		'value',
		'tag'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'instance creation' }
StInspectorDynamicNode class >> hostObject: anObject label: aString value: anotherObject [
	^ (self hostObject: anObject) 
		label: aString;
		rawValue: anotherObject;
		yourself
]

{ #category : #accessing }
StInspectorDynamicNode >> key [
	^ label
]

{ #category : #accessing }
StInspectorDynamicNode >> label [
	^ label
]

{ #category : #accessing }
StInspectorDynamicNode >> label: aString [
	label := aString
]

{ #category : #accessing }
StInspectorDynamicNode >> rawValue [
	^ value
]

{ #category : #accessing }
StInspectorDynamicNode >> rawValue: anObject [
	value := anObject
]

{ #category : #accessing }
StInspectorDynamicNode >> variableTag [
	^  tag ifNil: [ super variableTag ]
]

{ #category : #accessing }
StInspectorDynamicNode >> variableTag: aTag [
	tag := aTag
]
