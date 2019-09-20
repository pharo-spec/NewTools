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
StPresenterInspection >> defineInputPorts [ 
	
	^ self presenter defineInputPorts
		collect: [ :each | 
			each copy 
				delegateTo: [ self presenter ];
				yourself ]
]

{ #category : #initialization }
StPresenterInspection >> defineOutputPorts [ 
	
	^ self presenter defineOutputPorts
		collect: [ :each | 
			each copy 
				delegateTo: [ self presenter ];
				yourself ]
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
