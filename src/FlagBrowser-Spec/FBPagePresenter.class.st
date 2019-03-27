"
Description
--------------------

I represent a tab of the FlagBrowser. 

We different subclasses will organize flags in different ways.

Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	code:					<aTextPresenter>		A text presenter to show the source code of the method containing the flag.
	locationsTable:		<aTablePresenter>		A table presenter to show the different locations to highlight to the user depending on the page organization.

"
Class {
	#name : #FBPagePresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'code',
		'locationsTable'
	],
	#category : #'FlagBrowser-Spec'
}

{ #category : #accessing }
FBPagePresenter class >> allPages [
	^ (self allSubclasses reject: #isAbstract) sorted: #priority ascending
]

{ #category : #specs }
FBPagePresenter class >> icon [
	^ self subclassResponsibility
]

{ #category : #accessing }
FBPagePresenter class >> priority [
	^ self subclassResponsibility
]

{ #category : #specs }
FBPagePresenter class >> title [
	^ self subclassResponsibility
]

{ #category : #accessing }
FBPagePresenter >> code [
	^ code
]

{ #category : #accessing }
FBPagePresenter >> code: anObject [
	code := anObject
]

{ #category : #initialization }
FBPagePresenter >> initializePresenter [
	code whenTextIsAcceptedDo: [ :text | code behavior compile: text ].
	
	locationsTable whenSelectedItemChangedDo: [ :location | self selectLocation: location ]
]

{ #category : #initialization }
FBPagePresenter >> initializeWidgets [
	locationsTable := self newTable.
	code := self newCode.

	locationsTable
		beResizable;
		activateOnDoubleClick;
		whenActivatedDo: [ :selection | selection selectedItem openInBrowser ];
		contextMenu: self tableMenu.

	code aboutToStyle: true
]

{ #category : #accessing }
FBPagePresenter >> locationsTable [
	^ locationsTable
]

{ #category : #accessing }
FBPagePresenter >> locationsTable: anObject [
	locationsTable := anObject
]

{ #category : #initialization }
FBPagePresenter >> selectLocation: location [
	^ self code
		text: location sourceCode;
		behavior: location classLocation;
		setSelection: location interval
]

{ #category : #initialization }
FBPagePresenter >> tableMenu [
	| aMenu |
	aMenu := MenuPresenter new.

	aMenu
		addGroup: [ :aGroup | 
			aGroup
				addItem: [ :anItem | 
					anItem
						name: 'Browse';
						icon: (self iconNamed: #smallFind);
						action: [ :param | self locationsTable selectedItem openInBrowser ] ] ].

	^ aMenu
]
