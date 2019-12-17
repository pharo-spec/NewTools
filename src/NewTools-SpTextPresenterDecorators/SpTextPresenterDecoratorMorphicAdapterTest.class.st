Class {
	#name : #SpTextPresenterDecoratorMorphicAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'decorator'
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
	decorator iconBlock: [ :seg| seg]
]

{ #category : #tests }
SpTextPresenterDecoratorMorphicAdapterTest >> testAddTextPresenterDecorator [
]

{ #category : #tests }
SpTextPresenterDecoratorMorphicAdapterTest >> testTransformTextPresenterDecoratorToSegment [
]
