"
I open the RT help browser presenter.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : 'StRewriterOpenHelpBrowserCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-RewriterTools-Commands',
	#package : 'NewTools-RewriterTools',
	#tag : 'Commands'
}

{ #category : 'default' }
StRewriterOpenHelpBrowserCommand class >> defaultDescription [

	^ 'Help browser'
]

{ #category : 'accessing' }
StRewriterOpenHelpBrowserCommand class >> defaultIconName [

	^ #smallQuestion
]

{ #category : 'default' }
StRewriterOpenHelpBrowserCommand class >> defaultName [

	^ 'More help'
]

{ #category : 'executing' }
StRewriterOpenHelpBrowserCommand >> execute [

	^ StRewriterHelpBrowserPresenter new open
	
]
