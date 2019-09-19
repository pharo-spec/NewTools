Class {
	#name : #StHeaderBar,
	#superclass : #SpPresenter,
	#instVars : [
		'titleLabel'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StHeaderBar class >> defaultSpec [

	^ SpBoxLayout newHorizontal
		add: #titleLabel;
		yourself
]

{ #category : #initialization }
StHeaderBar >> initializePresenters [

	titleLabel := self newLabel
]

{ #category : #accessing }
StHeaderBar >> label: aString [

	titleLabel label: aString
]
