"
I am a command that opens the rt basic editor presenter from another presenter keeping the same code.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #StRewriterOpenRuleEditorCommand,
	#superclass : #StCommand,
	#category : #'NewTools-RewriterTools-Commands'
}

{ #category : #default }
StRewriterOpenRuleEditorCommand class >> defaultDescription [

	^ 'Open Rewrite Rule Editor'
]

{ #category : #accessing }
StRewriterOpenRuleEditorCommand class >> defaultIconName [

	^StRewriterRuleEditorPresenter iconName
]

{ #category : #default }
StRewriterOpenRuleEditorCommand class >> defaultName [

	^ 'Open Rule Editor'
]

{ #category : #executing }
StRewriterOpenRuleEditorCommand >> execute [

	| window |
	window := StRewriterRuleEditorPresenter new open.
	window presenter
		lhs: self context lhs;
		rhs: self context rhs.
	^ window
]
