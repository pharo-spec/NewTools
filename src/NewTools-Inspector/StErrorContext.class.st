"
I represent an erroneous inspector context.
I arrive when an inspector context fails with an exception.
In that case, I force the inspection presenter to be a debug inspection presenter.
"
Class {
	#name : 'StErrorContext',
	#superclass : 'StInspectionContext',
	#instVars : [
		'error'
	],
	#category : 'NewTools-Inspector-Model',
	#package : 'NewTools-Inspector',
	#tag : 'Model'
}

{ #category : 'initialization' }
StErrorContext >> basicNewInspectionPresenter [

	^ self debugInspectorPresenter
]

{ #category : 'initialization' }
StErrorContext >> getError [

	^ error
]

{ #category : 'testing' }
StErrorContext >> isErrorContext [
	
	^ true
]

{ #category : 'initialization' }
StErrorContext >> setError: anError [

	error := anError
]
