"
I am a command that applies the rule that is already present on the presenter to a seleted set of classes.

I can be converted into a sepc button to be used in a presenter
"
Class {
	#name : 'StRewriterApplyRuleOnSelectedClassesCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-RewriterTools-Commands',
	#package : 'NewTools-RewriterTools',
	#tag : 'Commands'
}

{ #category : 'default' }
StRewriterApplyRuleOnSelectedClassesCommand class >> defaultDescription [

	^ 'Apply the current rewrite rule that is on this tool a selected scope.'
]

{ #category : 'accessing' }
StRewriterApplyRuleOnSelectedClassesCommand class >> defaultIconName [

	^ StRewriterScopeSelectorPresenter iconName
]

{ #category : 'default' }
StRewriterApplyRuleOnSelectedClassesCommand class >> defaultName [

	^ 'Transform selected classes'
]

{ #category : 'executing' }
StRewriterApplyRuleOnSelectedClassesCommand >> execute [

	| dialogWindow changes |
	dialogWindow := self context scopeSelectorPresenter openDialog.
	dialogWindow okAction: [
		| ruleHolder |
		ruleHolder := StRewriterRuleHolder
			lhs: self context lhs
			rhs: self context rhs
			isForMethod: self context isRuleForMethod.

		changes := StRewriterAbstractApplier defaultEngineApplier
			calculateChangesForClasses: self context scopeSelectorPresenter selectedClasses
			transformationRules: ruleHolder asOrderedCollection.
		(ChangesBrowser changes: changes) open ]
]
