Class {
	#name : #FBByFlagsPagePresenter,
	#superclass : #FBPagePresenter,
	#instVars : [
		'modeDropbox',
		'flagsList'
	],
	#category : #'FlagBrowser-Spec'
}

{ #category : #specs }
FBByFlagsPagePresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #modeDropbox withConstraints: [ :constraints | constraints height: 30 ];
		add:
			(SpecPanedLayout newHorizontal
				position: 250;
				add: #flagsList;
				add:
					(SpecPanedLayout newVertical
						add: #locationsTable;
						add: #code;
						yourself);
				yourself);
		yourself
]

{ #category : #specs }
FBByFlagsPagePresenter class >> icon [
	^ #breakpoint
]

{ #category : #accessing }
FBByFlagsPagePresenter class >> priority [
	^ 1
]

{ #category : #specs }
FBByFlagsPagePresenter class >> title [
	^ 'By flag'
]

{ #category : #accessing }
FBByFlagsPagePresenter >> flagsList [
	^ flagsList
]

{ #category : #accessing }
FBByFlagsPagePresenter >> flagsList: anObject [
	flagsList := anObject
]

{ #category : #initialization }
FBByFlagsPagePresenter >> initializePresenter [
	super initializePresenter.

	flagsList
		whenSelectionChangedDo: [ :selection | 
			self locationsTable
				items: selection selectedItem locations;
				selectIndex: 1 ].

	modeDropbox
		whenSelectedItemChangedDo: [ :mode | 
			self flagsList
				items: mode allFlags;
				selectIndex: 1 ];
		selectedItem: FBSymbolFlag
]

{ #category : #initialization }
FBByFlagsPagePresenter >> initializeWidgets [
	super initializeWidgets.
	modeDropbox := self newDropList.
	flagsList := self newList.

	modeDropbox
		items: FBFlag withAllSubclasses;
		displayBlock: [ :class | class title ].

	flagsList
		displayBlock: [ :flag | flag parameter asString , ' (' , flag locations size asString , ' occurences)' ];
		sortingBlock: [ :flag | flag parameter asString ] ascending.

	locationsTable
		addColumn: (StringTableColumn title: 'Class' evaluated: #classLocation);
		addColumn: (StringTableColumn title: 'Method' evaluated: #selector)
]

{ #category : #accessing }
FBByFlagsPagePresenter >> modeDropbox [
	^ modeDropbox
]

{ #category : #accessing }
FBByFlagsPagePresenter >> modeDropbox: anObject [
	modeDropbox := anObject
]
