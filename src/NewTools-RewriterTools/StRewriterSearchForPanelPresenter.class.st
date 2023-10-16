"
I am the panel for the search for (lhs) part of the rule
"
Class {
	#name : 'StRewriterSearchForPanelPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'label',
		'codePresenter'
	],
	#category : 'NewTools-RewriterTools-Widgets',
	#package : 'NewTools-RewriterTools',
	#tag : 'Widgets'
}

{ #category : 'layout' }
StRewriterSearchForPanelPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: label expand: false;
		add: codePresenter;
		yourself
]

{ #category : 'initialization' }
StRewriterSearchForPanelPresenter >> initializePresenters [

	label := self newLabel.
	label label: 'Search for:'.

	codePresenter := self newCode.
	codePresenter
		text: StRewriterDemoRules defaultRule lhs;
		withoutSyntaxHighlight;
		withoutLineNumbers
]

{ #category : 'accessing' }
StRewriterSearchForPanelPresenter >> lhs [

	^ codePresenter text
]

{ #category : 'accessing' }
StRewriterSearchForPanelPresenter >> lhs: aString [

	codePresenter text: aString
]
