Class {
	#name : #StDebuggerFailingAssertionInspector,
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
StDebuggerFailingAssertionInspector class >> defaultSpec [
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
StDebuggerFailingAssertionInspector class >> diffInspectorsFromActual: actualObject expected: expectedObject [
	^ self basicNew
		  actualObject: actualObject;
		  expectedObject: expectedObject;
		  initialize
]

{ #category : #accessing }
StDebuggerFailingAssertionInspector >> actualObject: anObject [
	actualObject := anObject
]

{ #category : #accessing }
StDebuggerFailingAssertionInspector >> expectedObject: anObject [
	expectedObject := anObject
]

{ #category : #initialization }
StDebuggerFailingAssertionInspector >> initializeMillerList: list forObject: object [
	list
		presenterBlock: [ :aModel | self treeTableInspectionFor: aModel ];
		setRootModel: object 
]

{ #category : #initialization }
StDebuggerFailingAssertionInspector >> initializePresenters [
	actualObjectHeader := (self instantiate: StHeaderBar)
		                      label:
			                      'Actual object: ' , actualObject printString;
		                      yourself.
	actualObjectHeader applyStyleToLabel: 'label.headerError'.
	actualObjectMillerList := SpMillerColumnPresenter new.
	self
		initializeMillerList: actualObjectMillerList
		forObject: actualObject.
	expectedObjectHeader := (self instantiate: StHeaderBar)
		                        label:
			                        'Expected object: '
			                        , expectedObject printString;
		                        yourself.
	expectedObjectHeader applyStyleToLabel: 'label.headerSuccess'.
	expectedObjectMillerList := SpMillerColumnPresenter new.
	self
		initializeMillerList: expectedObjectMillerList
		forObject: expectedObject
]

{ #category : #views }
StDebuggerFailingAssertionInspector >> treeTableInspectionFor: aModel [
	| rawInspection |
	rawInspection := StRawInspection new.
	^ self newTreeTable
		  roots: aModel value allInspectorNodes;
		  children: [ :node | node children ];
		  addColumn: rawInspection variablesColumn;
		  addColumn: rawInspection valuesColumn;
		  yourself
]
