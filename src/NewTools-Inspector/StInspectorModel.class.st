Class {
	#name : #StInspectorModel,
	#superclass : #Object,
	#instVars : [
		'inspectedObject'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'instance creation' }
StInspectorModel class >> new [ 

	self error: 'Use #on:'
]

{ #category : #'instance creation' }
StInspectorModel class >> on: anObject [

	^ super new inspectedObject: anObject
]

{ #category : #accessing }
StInspectorModel >> inspectedObject [
	^ inspectedObject
]

{ #category : #accessing }
StInspectorModel >> inspectedObject: anObject [
	inspectedObject := anObject
]

{ #category : #accessing }
StInspectorModel >> objectInspectionPages [

	^ self inspectedObject inspectionPages
]
