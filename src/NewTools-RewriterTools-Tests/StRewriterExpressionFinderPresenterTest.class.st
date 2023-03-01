"
An ExpressionFinderPresenterTest is a test class for testing the behavior of ExpressionFinderPresenter
"
Class {
	#name : #StRewriterExpressionFinderPresenterTest,
	#superclass : #StRewriterAbstractToolTest,
	#instVars : [
		'expressionFinder'
	],
	#category : #'NewTools-RewriterTools-Tests-ExpressionFinder'
}

{ #category : #running }
StRewriterExpressionFinderPresenterTest >> setUp [

	super setUp.
	expressionFinder := StRewriterExpressionFinderPresenter new
]

{ #category : #tests }
StRewriterExpressionFinderPresenterTest >> testPatternCode [

	expressionFinder patternCode: 'A pattern'.
	self assert: expressionFinder patternCode equals: 'A pattern'
]

{ #category : #accessing }
StRewriterExpressionFinderPresenterTest >> toolClass [

	^ StRewriterExpressionFinderPresenter
]
