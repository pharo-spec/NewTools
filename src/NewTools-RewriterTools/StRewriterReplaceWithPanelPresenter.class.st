"
I am the panel for the replace with (rhs) part of the rule
"
Class {
	#name : #StRewriterReplaceWithPanelPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'label',
		'codePresenter'
	],
	#category : #'NewTools-RewriterTools-Widgets'
}

{ #category : #layout }
StRewriterReplaceWithPanelPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: label expand: false;
		  add: codePresenter;
		  yourself
]

{ #category : #initialization }
StRewriterReplaceWithPanelPresenter >> initializePresenters [

	label := self newLabel.
	label label: 'Replace with:'.

	codePresenter := self newCode.
	codePresenter
		text: StRewriterDemoRules defaultRule rhs;
		withoutSyntaxHighlight;
		withoutLineNumbers
]

{ #category : #accessing }
StRewriterReplaceWithPanelPresenter >> rhs [

	^ codePresenter text
]

{ #category : #accessing }
StRewriterReplaceWithPanelPresenter >> rhs: aString [

	codePresenter text: aString
]
