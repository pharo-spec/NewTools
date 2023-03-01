"
I am a presenter for displaying the ocurrences found by `ExpressionFinderPresenter`
"
Class {
	#name : #StRewriterOccurrencesBrowserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'codePresenter',
		'listPresenter'
	],
	#category : #'NewTools-RewriterTools-ChangesBrowser'
}

{ #category : #accessing }
StRewriterOccurrencesBrowserPresenter class >> critiques: critiques [

	^ self new
		critiques: critiques;
		yourself
]

{ #category : #specs }
StRewriterOccurrencesBrowserPresenter class >> title [

	^ 'Occurrences matches'
]

{ #category : #initialization }
StRewriterOccurrencesBrowserPresenter >> connectPresenters [

	listPresenter whenSelectedDo: [ :selectedItem |
		codePresenter text: selectedItem sourceAnchor entity sourceCode.
		codePresenter selectionInterval: selectedItem sourceAnchor interval ]
]

{ #category : #accessing }
StRewriterOccurrencesBrowserPresenter >> critiques: critiques [

	listPresenter items: critiques
]

{ #category : #layout }
StRewriterOccurrencesBrowserPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		add: listPresenter;
		add: codePresenter;
		positionOfSlider: 30 percent;
		yourself
]

{ #category : #initialization }
StRewriterOccurrencesBrowserPresenter >> initializePresenters [

	codePresenter := self newCode.

	listPresenter := self newList.
	listPresenter
		activateOnSingleClick;
		headerTitle: 'Matches founded';
		display: [ :item | item sourceAnchor entity printString ]
]

{ #category : #initialization }
StRewriterOccurrencesBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 800 @ 500;
		askOkToClose: false
]
