"
I am a command that open the rt rule loader presenter from another presenter.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : 'StRewriterOpenRuleLoaderCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-RewriterTools-Commands',
	#package : 'NewTools-RewriterTools',
	#tag : 'Commands'
}

{ #category : 'default' }
StRewriterOpenRuleLoaderCommand class >> defaultDescription [

	^ 'Load an example Rewrite Rule'
]

{ #category : 'accessing' }
StRewriterOpenRuleLoaderCommand class >> defaultIconName [

	^ StRewriterRuleLoaderPresenter iconName
]

{ #category : 'default' }
StRewriterOpenRuleLoaderCommand class >> defaultName [

	^ 'Load an example rule'
]

{ #category : 'executing' }
StRewriterOpenRuleLoaderCommand >> execute [
	
	^  StRewriterRuleLoaderPresenter new open.
	
]
