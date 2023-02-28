"
I am the panel for the replace with (rhs) part of the rule
"
Class {
	#name : #StRewriterReplaceWithPanel,
	#superclass : #SpPresenter,
	#instVars : [
		'label',
		'codePresenter'
	],
	#category : #'NewTools-RewriterTools-Widgets'
}

{ #category : #layout }
StRewriterReplaceWithPanel >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: label expand: false;
		  add: codePresenter;
		  yourself
]

{ #category : #initialization }
StRewriterReplaceWithPanel >> initializePresenters [

	label := self newLabel.
	label label: 'Replace with:'.

	codePresenter := self newCode.
	codePresenter
		text: StRewriterDemoRules defaultRule rhs;
		withoutSyntaxHighlight;
		withoutLineNumbers
]

{ #category : #accessing }
StRewriterReplaceWithPanel >> rhs [

	^ codePresenter text
]

{ #category : #accessing }
StRewriterReplaceWithPanel >> rhs: aString [

	codePresenter text: aString
]
