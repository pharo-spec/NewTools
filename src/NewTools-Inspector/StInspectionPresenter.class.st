"
A base inspection on an inspectionModel (which contains an inspected object).
Inspections are ways to see/inspect an object. 
They are the pages seen in the basic inspector.
"
Class {
	#name : 'StInspectionPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'context'
	],
	#category : 'NewTools-Inspector-View',
	#package : 'NewTools-Inspector',
	#tag : 'View'
}

{ #category : 'api' }
StInspectionPresenter >> activateOnDoubleClick [

]

{ #category : 'api' }
StInspectionPresenter >> activateOnSingleClick [
]

{ #category : 'converting' }
StInspectionPresenter >> asInspection [

	^ self
]

{ #category : 'accessing' }
StInspectionPresenter >> context [

	^ context
]

{ #category : 'accessing' }
StInspectionPresenter >> context: aContext [

	context := aContext
]

{ #category : 'testing' }
StInspectionPresenter >> enableSlotMenuEntries [
	^false
]

{ #category : 'testing' }
StInspectionPresenter >> hasOutputActivationPort [

	^ false
]

{ #category : 'accessing - model' }
StInspectionPresenter >> model [
	^ model
]

{ #category : 'accessing - model' }
StInspectionPresenter >> model: anInspectionModel [

	model := anInspectionModel
]

{ #category : 'accessing - model' }
StInspectionPresenter >> setModelBeforeInitialization: anInspectionModel [ 

	model := anInspectionModel
]

{ #category : 'stepping' }
StInspectionPresenter >> step [
	"do nothing, it depends on my children"
]
