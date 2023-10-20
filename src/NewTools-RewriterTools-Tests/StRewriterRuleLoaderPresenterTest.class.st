Class {
	#name : 'StRewriterRuleLoaderPresenterTest',
	#superclass : 'StRewriterAbstractToolTest',
	#instVars : [
		'ruleLoader'
	],
	#category : 'NewTools-RewriterTools-Tests-RuleLoader',
	#package : 'NewTools-RewriterTools-Tests',
	#tag : 'RuleLoader'
}

{ #category : 'running' }
StRewriterRuleLoaderPresenterTest >> setUp [

	super setUp.
	ruleLoader := StRewriterRuleLoaderPresenter new
]

{ #category : 'accessing' }
StRewriterRuleLoaderPresenterTest >> toolClass [

	^ StRewriterRuleLoaderPresenter
]
