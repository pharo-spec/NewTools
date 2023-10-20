"
A RewriteRulesHelpPresenterTest is a test class for testing the behavior of RewriteRulesHelpPresenter
"
Class {
	#name : 'StRewriterRulesHelpPresenterTest',
	#superclass : 'StRewriterAbstractToolTest',
	#instVars : [
		'rulesHelper'
	],
	#category : 'NewTools-RewriterTools-Tests-HelpBrowser',
	#package : 'NewTools-RewriterTools-Tests',
	#tag : 'HelpBrowser'
}

{ #category : 'running' }
StRewriterRulesHelpPresenterTest >> setUp [

	super setUp.

	rulesHelper := StRewriterHelpBrowserPresenter new
]

{ #category : 'tests' }
StRewriterRulesHelpPresenterTest >> testCreateTextMorph [

	| morph |
	morph := rulesHelper createTextMorph.
	self assert: (morph isMemberOf: RubScrolledTextMorph)
]

{ #category : 'tests' }
StRewriterRulesHelpPresenterTest >> testGetMicrodownParsedText [

	| aText |
	aText := rulesHelper class getParsedText.
	self assert: aText isNotEmpty
]

{ #category : 'accessing' }
StRewriterRulesHelpPresenterTest >> toolClass [

	^ StRewriterRuleLoaderPresenter
]
