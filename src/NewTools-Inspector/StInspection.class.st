Class {
	#name : #StInspection,
	#superclass : #SpPresenter,
	#instVars : [
		'model'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StInspection class >> title [
	^self subclassResponsibility
]

{ #category : #'model access' }
StInspection >> model [
	^ model
]

{ #category : #'model access' }
StInspection >> model: anObject [
	model := anObject
]

{ #category : #'model access' }
StInspection >> setModelBeforeInitialization: anObject [ 

	model := anObject
]

{ #category : #TOREMOVE }
StInspection >> title [
	^self class title
]
