"
I am the panel for the search for (lhs) part of the rule
"
Class {
	#name : #StRewriterSearchForPanel,
	#superclass : #SpPresenter,
	#instVars : [
		'label',
		'codePresenter'
	],
	#category : #'NewTools-RewriterTools-Widgets'
}

{ #category : #layout }
StRewriterSearchForPanel >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: label expand: false;
		add: codePresenter;
		yourself
]

{ #category : #initialization }
StRewriterSearchForPanel >> initializePresenters [

	label := self newLabel.
	label label: 'Search for:'.

	codePresenter := self newCode.
	codePresenter
		text: StRewriterDemoRules defaultRule lhs;
		withoutSyntaxHighlight;
		withoutLineNumbers
]

{ #category : #accessing }
StRewriterSearchForPanel >> lhs [

	^ codePresenter text
]

{ #category : #accessing }
StRewriterSearchForPanel >> lhs: aString [

	codePresenter text: aString
]
