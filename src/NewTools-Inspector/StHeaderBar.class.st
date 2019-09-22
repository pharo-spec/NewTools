Class {
	#name : #StHeaderBar,
	#superclass : #SpPresenter,
	#instVars : [
		'titleLabel',
		'toolbar'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StHeaderBar class >> defaultSpec [

	^ SpBoxLayout newHorizontal
		beNotHomogeneous;
		borderWidth: 3;
		add: #titleLabel;
		addLast: #toolbar expand: false;
		yourself
]

{ #category : #initialization }
StHeaderBar >> initializePresenters [

	titleLabel := self newLabel.
	toolbar := self newToolBar.
	toolbar beIcons
]

{ #category : #accessing }
StHeaderBar >> label: aString [

	titleLabel label: aString
]

{ #category : #accessing }
StHeaderBar >> toolbarActions: aCommandGroup [

	toolbar removeAllItems.
	SpToolBarPresenterBuilder new 
		toolbarPresenter: toolbar;
		visit: aCommandGroup
]
