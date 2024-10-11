"
I present a side-by-side view of a failing assert, with at my left an inspector on the failing object and at my left the expected object.

Only opens for following assertions failures:
#assert:equals: 
#assert:closeTo:precision: 
#assert:closeTo: 
#assert:identicalTo: 
#assertCollection:equals: 
#assertCollection:hasSameElements:
"
Class {
	#name : 'StFailingAssertionInspector',
	#superclass : 'SpPresenter',
	#instVars : [
		'actualObjectHeader',
		'expectedObjectHeader',
		'actualObject',
		'expectedObject',
		'actualObjectMillerList',
		'expectedObjectMillerList',
		'stringDiff'
	],
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'layout' }
StFailingAssertionInspector class >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 50 percent;
		  add: (SpBoxLayout newTopToBottom
				   add: #actualObjectHeader expand: false;
				   add: #actualObjectMillerList;
				   yourself);
		  add: (SpBoxLayout newTopToBottom
				   add: #expectedObjectHeader expand: false;
				   add: #expectedObjectMillerList;
				   yourself);
		  yourself
]

{ #category : 'instance creation' }
StFailingAssertionInspector class >> diffInspectorsFromActual: actualObject expected: expectedObject application: aStApplication [

	| diffPresenter |
	diffPresenter := self basicNew
		                 application: aStApplication;
		                 actualObject: actualObject;
		                 expectedObject: expectedObject;
		                 initialize.

	self flag: 'Not nice but works. This needs improvement.'.
	(actualObject isString and: [ expectedObject isString ]) ifTrue: [ 
		diffPresenter buildWithSelector: #stringSpec ].
	^ diffPresenter
]

{ #category : 'specs' }
StFailingAssertionInspector class >> stringSpec [
	^ SpBoxLayout newTopToBottom
		add: #stringDiff;
		yourself
]

{ #category : 'accessing' }
StFailingAssertionInspector >> actualObject [
	^ actualObject
]

{ #category : 'accessing' }
StFailingAssertionInspector >> actualObject: anObject [
	actualObject := anObject
]

{ #category : 'accessing' }
StFailingAssertionInspector >> actualObjectMillerList [
	^ actualObjectMillerList
]

{ #category : 'accessing' }
StFailingAssertionInspector >> expectedObject [
	^ expectedObject
]

{ #category : 'accessing' }
StFailingAssertionInspector >> expectedObject: anObject [
	expectedObject := anObject
]

{ #category : 'accessing' }
StFailingAssertionInspector >> expectedObjectMillerList [
	^ expectedObjectMillerList
]

{ #category : 'initialization' }
StFailingAssertionInspector >> initializeMillerList: list forObject: object [
	list
		presenterBlock: [ :aModel | self treeTableInspectionFor: aModel ];
		setRootModel: object 
]

{ #category : 'initialization' }
StFailingAssertionInspector >> initializeObjectDiffPresenters [
			
	actualObjectHeader := (self instantiate: StHeaderBar)
		label: 'Actual object: ' , (actualObject printStringLimitedTo: 40);
		yourself.
	actualObjectMillerList := SpMillerColumnPresenter new.
	self
		initializeMillerList: actualObjectMillerList
		forObject: actualObject.
		
	expectedObjectHeader := (self instantiate: StHeaderBar)
		label: 'Expected object: ' , (expectedObject printStringLimitedTo: 40);
		yourself.	
	expectedObjectMillerList := SpMillerColumnPresenter new.
	self
		initializeMillerList: expectedObjectMillerList
		forObject: expectedObject
]

{ #category : 'initialization' }
StFailingAssertionInspector >> initializePresenters [

	actualObject presentDiffWith: expectedObject in: self
]

{ #category : 'initialization' }
StFailingAssertionInspector >> initializeStringDiffPresenters [
	
	stringDiff :=  self instantiate: SpDiffUnifiedPresenter .
	stringDiff showOptions: false.
	stringDiff leftLabel: 'Actual result (left) versus expected result (right)'.
	stringDiff rightLabel: ''.
	stringDiff leftText: actualObject printString.
	stringDiff rightText: expectedObject printString

]

{ #category : 'accessing' }
StFailingAssertionInspector >> stringDiff [
	^stringDiff
]

{ #category : 'views' }
StFailingAssertionInspector >> treeTableInspectionFor: aModel [
	| rawInspection |
	rawInspection := StRawInspectionPresenter new.
	^ self newTreeTable
		  roots: aModel value allInspectorNodes;
		  children: [ :node | node children ];
		  addColumn: rawInspection variablesColumn;
		  addColumn: rawInspection valuesColumn;
		  yourself
]
