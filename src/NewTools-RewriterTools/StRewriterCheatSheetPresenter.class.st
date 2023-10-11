"
I am a cheat sheet for showing help for the rewriting rules
"
Class {
	#name : 'StRewriterCheatSheetPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'textPresenter',
		'helpButton'
	],
	#category : 'NewTools-RewriterTools-Help',
	#package : 'NewTools-RewriterTools',
	#tag : 'Help'
}

{ #category : 'layout' }
StRewriterCheatSheetPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: helpButton expand: false;
		add: textPresenter;
		yourself
]

{ #category : 'accessing' }
StRewriterCheatSheetPresenter >> helpText [

	^ '` = meta var

@ = list

` = recurse into

. = statement

# = literal'
]

{ #category : 'initialization' }
StRewriterCheatSheetPresenter >> initializePresenters [

	textPresenter := self newText.
	textPresenter
		text: self helpText;
		beNotEditable.

	helpButton := self instantiate: (StRewriterOpenHelpBrowserCommand forSpecContext: self) asButtonPresenter.

	self initializeStyles
]

{ #category : 'initialization' }
StRewriterCheatSheetPresenter >> initializeStyles [

	textPresenter addStyle: 'bgOpaque'
]
