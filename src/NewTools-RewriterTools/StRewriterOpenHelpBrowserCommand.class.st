"
I open the RT help browser presenter.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : #StRewriterOpenHelpBrowserCommand,
	#superclass : #StCommand,
	#category : #'NewTools-RewriterTools-Commands'
}

{ #category : #default }
StRewriterOpenHelpBrowserCommand class >> defaultDescription [

	^ 'Help browser'
]

{ #category : #accessing }
StRewriterOpenHelpBrowserCommand class >> defaultIconName [

	^ #smallQuestionIcon
]

{ #category : #default }
StRewriterOpenHelpBrowserCommand class >> defaultName [

	^ 'More help'
]

{ #category : #executing }
StRewriterOpenHelpBrowserCommand >> execute [

	| window |
	window := StRewriterHelpBrowserPresenter new open.
	^ window
]
