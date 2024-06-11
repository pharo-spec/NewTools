Class {
	#name : 'StRewriterRuleEditorPresenterTest',
	#superclass : 'StRewriterAbstractToolTest',
	#instVars : [
		'rewriteBasicEditor'
	],
	#category : 'NewTools-RewriterTools-Tests-BasicEditor',
	#package : 'NewTools-RewriterTools-Tests',
	#tag : 'BasicEditor'
}

{ #category : 'running' }
StRewriterRuleEditorPresenterTest >> setUp [

	super setUp.
	rewriteBasicEditor := StRewriterRuleEditorPresenter new
]

{ #category : 'tests' }
StRewriterRuleEditorPresenterTest >> testReplaceWithPatternCode [

	rewriteBasicEditor rhs: 'patternCode'.
	self
		assert: rewriteBasicEditor rhs
		equals: 'patternCode'
]

{ #category : 'tests' }
StRewriterRuleEditorPresenterTest >> testRuleLoadsCorrectly [

	| ruleHolder |
	ruleHolder := StRewriterRuleHolder lhs: '`aVar foo' rhs: '`aVar otherFoo'.

	rewriteBasicEditor
		lhs: ruleHolder lhs;
		rhs: ruleHolder rhs.

	self	assert: rewriteBasicEditor lhs equals: ruleHolder lhs.
	self	assert: rewriteBasicEditor rhs equals: ruleHolder rhs
]

{ #category : 'tests' }
StRewriterRuleEditorPresenterTest >> testSearchForPatternCode [

	rewriteBasicEditor lhs: 'patternCode'.
	self
		assert: rewriteBasicEditor lhs
		equals: 'patternCode'
]

{ #category : 'accessing' }
StRewriterRuleEditorPresenterTest >> toolClass [

	^ StRewriterRuleEditorPresenter
]
