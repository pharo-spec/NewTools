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
	adapter := SpMorphicTextAdapter new.
	widget := RubScrolledTextMorph on: adapter.
	adapter widget: adapter
]

{ #category : #tests }
SpTextPresenterDecoratorMorphicAdapterTest >> testAddTextPresenterDecorator [
]

{ #category : #tests }
SpTextPresenterDecoratorMorphicAdapterTest >> testTransformTextPresenterDecoratorToSegment [
]
