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
SpTextPresenterDecoratorTest >> testForHighlight [

	decorator := SpTextPresenterDecorator forHighlight.
	
	self 
		assert: decorator highlightColor 
		equals: SpTextPresenterDecorator defaultHighlightColor.
	self 
		assert: decorator underlineColor
		equals: SpTextPresenterDecorator defaultUnderlineColor
]

{ #category : #tests }
SpTextPresenterDecoratorTest >> testStartStop [
	decorator interval: (0 to: 10).
	self assert: decorator start equals: 0.
	self assert: decorator stop equals: 10.
]
