"
An inspection container to hold any kind of presenter and show them as inspections.
Called in `SpPresenter>>#asInspection`, a presenter inspection is used to build an inspector, when collecting the inspections defined for the instance.
"
Class {
	#name : 'StPresenterInspectionPresenter',
	#superclass : 'StInspectionPresenter',
	#instVars : [
		'presenter'
	],
	#category : 'NewTools-Inspector-View',
	#package : 'NewTools-Inspector',
	#tag : 'View'
}

{ #category : 'layout' }
StPresenterInspectionPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: #presenter;
		yourself
]

{ #category : 'instance creation' }
StPresenterInspectionPresenter class >> for: aPresenter [

	^ self new
		presenter: aPresenter;
		yourself
]

{ #category : 'accessing' }
StPresenterInspectionPresenter >> activateOnDoubleClick [

	self presenter activateOnDoubleClick
]

{ #category : 'accessing' }
StPresenterInspectionPresenter >> activateOnSingleClick [

	self presenter activateOnSingleClick
]

{ #category : 'ports' }
StPresenterInspectionPresenter >> defaultOutputPort [
	
	^ self presenter defaultOutputPort
]

{ #category : 'testing' }
StPresenterInspectionPresenter >> hasOutputActivationPort [

	^ self presenter respondsTo: #outputActivationPort
	
]

{ #category : 'ports' }
StPresenterInspectionPresenter >> outputActivationPort [

	^ self presenter outputActivationPort
]

{ #category : 'accessing' }
StPresenterInspectionPresenter >> presenter [
	^ presenter
]

{ #category : 'accessing' }
StPresenterInspectionPresenter >> presenter: aPresenter [

	aPresenter owner: self.
	presenter := aPresenter
]
