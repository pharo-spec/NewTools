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
	#name : #StFailingAssertionInspector,
	#superclass : #SpPresenter,
	#instVars : [
		'actualObjectHeader',
		'expectedObjectHeader',
		'actualObject',
		'expectedObject',
		'actualObjectMillerList',
		'expectedObjectMillerList'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
StFailingAssertionInspector class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		  position: 50 percent;
		  add: (SpBoxLayout newVertical
				   add: #actualObjectHeader
				   expand: false
				   fill: false
				   padding: 0;
				   add: #actualObjectMillerList;
				   yourself);
		  add: (SpBoxLayout newVertical
				   add: #expectedObjectHeader
				   expand: false
				   fill: false
				   padding: 0;
				   add: #expectedObjectMillerList;
				   yourself);
		  yourself
]

{ #category : #'instance creation' }
StFailingAssertionInspector class >> diffInspectorsFromActual: actualObject expected: expectedObject application: aStApplication [
	^ self basicNew
		application: aStApplication;
		actualObject: actualObject;
		expectedObject: expectedObject;
		initialize
]

{ #category : #accessing }
StFailingAssertionInspector >> actualObject [
	^ actualObject
]

{ #category : #accessing }
StFailingAssertionInspector >> actualObject: anObject [
	actualObject := anObject
]

{ #category : #accessing }
StFailingAssertionInspector >> expectedObject [
	^ expectedObject
]

{ #category : #accessing }
StFailingAssertionInspector >> expectedObject: anObject [
	expectedObject := anObject
]

{ #category : #initialization }
StFailingAssertionInspector >> initializeMillerList: list forObject: object [
	list
		presenterBlock: [ :aModel | self treeTableInspectionFor: aModel ];
		setRootModel: object 
]

{ #category : #initialization }
StFailingAssertionInspector >> initializePresenters [

	actualObjectHeader := (self instantiate: StHeaderBar)
		label: 'Actual object: ', actualObject printString;
		yourself.
	actualObjectHeader applyStyleToLabel: 'label.headerError'.
	actualObjectMillerList := SpMillerColumnPresenter new.
	self
		initializeMillerList: actualObjectMillerList
		forObject: actualObject.
	expectedObjectHeader := (self instantiate: StHeaderBar)
		label: 'Expected object: ' , expectedObject printString;
		yourself.
	expectedObjectHeader applyStyleToLabel: 'label.headerSuccess'.
	expectedObjectMillerList := SpMillerColumnPresenter new.
	self
		initializeMillerList: expectedObjectMillerList
		forObject: expectedObject
]

{ #category : #views }
StFailingAssertionInspector >> treeTableInspectionFor: aModel [
	| rawInspection |
	rawInspection := StRawInspection new.
	^ self newTreeTable
		  roots: aModel value allInspectorNodes;
		  children: [ :node | node children ];
		  addColumn: rawInspection variablesColumn;
		  addColumn: rawInspection valuesColumn;
		  yourself
]
