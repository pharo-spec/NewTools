Class {
	#name : #StPresenterInspection,
	#superclass : #StInspection,
	#instVars : [
		'presenter'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StPresenterInspection class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #presenter;
		yourself
]

{ #category : #'instance creation' }
StPresenterInspection class >> for: aPresenter [

	^ self new
		presenter: aPresenter;
		yourself
]

{ #category : #initialization }
StPresenterInspection >> defaultOutputPort [
	
	^ self presenter defaultOutputPort
]

{ #category : #accessing }
StPresenterInspection >> presenter [
	^ presenter
]

{ #category : #accessing }
StPresenterInspection >> presenter: aPresenter [

	aPresenter owner: self.
	presenter := aPresenter
]
