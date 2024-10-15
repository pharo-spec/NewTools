"
I am a command that applies the rule that is already present on the presenter to all system classes.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : 'StRewriterApplyRuleOnAllClassesCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-RewriterTools-Commands',
	#package : 'NewTools-RewriterTools',
	#tag : 'Commands'
}

{ #category : 'default' }
StRewriterApplyRuleOnAllClassesCommand class >> defaultDescription [

	^ 'Apply the current rewrite rule that is on this tool to all classes in the system.'
]

{ #category : 'accessing' }
StRewriterApplyRuleOnAllClassesCommand class >> defaultIconName [

	^ StRewriterScopeSelectorPresenter iconName
]

{ #category : 'default' }
StRewriterApplyRuleOnAllClassesCommand class >> defaultName [

	^ 'Transform all classes'
]

{ #category : 'executing' }
StRewriterApplyRuleOnAllClassesCommand >> execute [

	| changes ruleHolder |
	self application
		confirm: 'This process can take between 1 and 2 minutes.'.

	ruleHolder := StRewriterRuleHolder
		lhs: self context lhs
		rhs: self context rhs
		isForMethod: self context isRuleForMethod.

	changes := StRewriterAbstractApplier defaultEngineApplier
		calculateAllChangesForRules: (OrderedCollection with: ruleHolder).
	^ (StChangesBrowserPresenter changes: changes) open
]
