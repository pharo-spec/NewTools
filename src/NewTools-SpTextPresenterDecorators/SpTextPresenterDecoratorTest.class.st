Class {
	#name : #SpTextPresenterDecoratorTest,
	#superclass : #TestCase,
	#instVars : [
		'decorator'
	],
	#category : #'NewTools-SpTextPresenterDecorators'
}

{ #category : #running }
SpTextPresenterDecoratorTest >> setUp [
	super setUp.
	decorator := SpTextPresenterDecorator new

]

{ #category : #tests }
SpTextPresenterDecoratorTest >> testAddHighlightStyle [
	decorator addHighlightDecoration.
	self assertCollection: decorator styles includesAll: {decorator class highlightStyleName.}
]

{ #category : #tests }
SpTextPresenterDecoratorTest >> testAddUnderlineStyle [
	decorator addUnderlineDecoration.
	self assertCollection: decorator styles includesAll: {decorator class underlineStyleName.}
]

{ #category : #tests }
SpTextPresenterDecoratorTest >> testDefaultStyle [
	self assertEmpty: decorator styles
]

{ #category : #tests }
SpTextPresenterDecoratorTest >> testMultipleStyles [
	decorator addHighlightDecoration.
	decorator addUnderlineDecoration.
	self assertCollection: decorator styles includesAll: { 
			decorator class highlightStyleName.
			decorator class underlineStyleName }
]

{ #category : #tests }
SpTextPresenterDecoratorTest >> testRemoveHighlightStyle [
	decorator addHighlightDecoration.
	decorator removeHighlightDecoration.
	self assertEmpty: decorator styles
]

{ #category : #tests }
SpTextPresenterDecoratorTest >> testRemoveUnderlineStyle [
	decorator addUnderlineDecoration.
	decorator removeUnderlineDecoration.
	self assertEmpty: decorator styles
]

{ #category : #tests }
SpTextPresenterDecoratorTest >> testStartStop [
	decorator interval: (0 to: 10).
	self assert: decorator start equals: 0.
	self assert: decorator stop equals: 10.
]
