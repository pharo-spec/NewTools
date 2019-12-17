Class {
	#name : #SpTextPresenterDecoratorMorphicAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'decorator',
		'adapter',
		'widget'
	],
	#category : #'NewTools-SpTextPresenterDecorators'
}

{ #category : #running }
SpTextPresenterDecoratorMorphicAdapterTest >> setUp [
	super setUp.
	decorator := SpTextPresenterDecorator new.
	decorator addHighlightDecoration.
	decorator highlightColor: Color red.	
	decorator addUnderlineDecoration.
	decorator underlineColor: Color green.
	decorator title: 'Test segment decoration'.
	decorator icon: (self iconNamed: #halt).
	decorator iconBlock: [ :seg| seg].
	decorator interval: (1 to: 42).
	adapter := SpMorphicTextAdapter adapt: SpTextPresenter new.
	widget := adapter widget
]

{ #category : #tests }
SpTextPresenterDecoratorMorphicAdapterTest >> testAddTextPresenterDecorator [
	self assertEmpty: widget segments.
	adapter addTextSegmentDecoration: decorator.
	self assert: widget segments size equals: 1.
	self assert: widget segments first class identicalTo: RubUnderlinedSegmentMorph 
]

{ #category : #tests }
SpTextPresenterDecoratorMorphicAdapterTest >> testTransformTextPresenterDecoratorToSegment [
]
