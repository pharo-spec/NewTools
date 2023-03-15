"
I am a command that opens match tool presenter from another presenter keeping the same code.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #StRewriterOpenMatchToolCommand,
	#superclass : #StCommand,
	#category : #'NewTools-RewriterTools-Commands'
}

{ #category : #default }
StRewriterOpenMatchToolCommand class >> defaultDescription [

	^ 'Open MatchTool'
]

{ #category : #accessing }
StRewriterOpenMatchToolCommand class >> defaultIconName [

	^ StRewriterMatchToolPresenter iconName
]

{ #category : #default }
StRewriterOpenMatchToolCommand class >> defaultName [

	^ 'Open Match Tool'
]

{ #category : #executing }
StRewriterOpenMatchToolCommand >> execute [

	^ StRewriterMatchToolPresenter new
		  patternCode: self context lhs;
		  pharoCode: '';
		  open
]
