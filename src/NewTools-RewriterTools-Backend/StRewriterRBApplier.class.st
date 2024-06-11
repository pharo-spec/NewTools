"
I use the RB rules to apply transformation rules to a set of methods
"
Class {
	#name : 'StRewriterRBApplier',
	#superclass : 'StRewriterAbstractApplier',
	#category : 'NewTools-RewriterTools-Backend-Core',
	#package : 'NewTools-RewriterTools-Backend',
	#tag : 'Core'
}

{ #category : 'api' }
StRewriterRBApplier class >> calculateAllChangesForRules: ruleHolderCollection [

	| env rewriter |
	env := StRewriterEnvironmentCreator scopeEnvironmentForAllPackages.
	rewriter := self rewriter: ruleHolderCollection.

	^ self obtainChanges: env rewriter: rewriter
]

{ #category : 'api' }
StRewriterRBApplier class >> calculateChangesForClasses: classes transformationRules: ruleHolderCollection [

	| env rewriter |
	env := StRewriterEnvironmentCreator scopeEnvironmentForClasses: classes.
	rewriter := self rewriter: ruleHolderCollection.

	^ self obtainChanges: env rewriter: rewriter
]

{ #category : 'private' }
StRewriterRBApplier class >> obtainChanges: env rewriter: rewriter [

	| checker transformationRule |
	transformationRule := RBTransformationRule new
		rewriteRule: rewriter;
		yourself.

	checker := RBSmalllintChecker new
		rule: transformationRule;
		environment: env.
	checker run.
	^ transformationRule changes
]

{ #category : 'private' }
StRewriterRBApplier class >> rewriter: ruleHolderCollection [

	| rewriter |
	rewriter := RBParseTreeRewriter new.
	ruleHolderCollection do: [ :ruleHolder |
		ruleHolder isRuleForMethod
			ifTrue: [ rewriter replaceMethod: ruleHolder lhs with: ruleHolder rhs ]
			ifFalse: [ rewriter replace: ruleHolder lhs with: ruleHolder rhs ] ].
	^ rewriter
]
