Class {
	#name : #FBByFlagsPagePresenter,
	#superclass : #FBPagePresenter,
	#instVars : [
		'selectedMode',
		'modeDropbox',
		'flagsList',
		'locationsTable',
		'code'
	],
	#category : #'FlagBrowser-Spec'
}

{ #category : #specs }
FBByFlagsPagePresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #modeDropbox withConstraints: [ :constraints | constraints height: 30 ];
		add:
			(SpecBoxLayout newHorizontal
				add: #flagsList withConstraints: [ :constraints | constraints width: 250 ];
				add:
					(SpecBoxLayout newVertical
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
FBByFlagsPagePresenter >> code [
	^ code
]

{ #category : #accessing }
FBByFlagsPagePresenter >> code: anObject [
	code := anObject
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
	locationsTable
		whenSelectedItemChangedDo: [ :location | 
			self code
				text: location sourceCode;
				behavior: location classLocation ].

	flagsList
		whenSelectionChangedDo: [ :selection | 
			self locationsTable
				items: selection selectedItem locations;
				selectIndex: 1 ].

	modeDropbox
		whenSelectedItemChangedDo: [ :mode | self selectedMode: mode ];
		selectedItem: FBSymbolFlag.
		
	code whenTextIsAcceptedDo: [ :text | code behavior compile: text ]
]

{ #category : #initialization }
FBByFlagsPagePresenter >> initializeWidgets [
	modeDropbox := self newDropList.
	flagsList := self newList.
	locationsTable := self newTable.
	code := self newCode.

	modeDropbox
		items: FBFlag withAllSubclasses;
		displayBlock: [ :class | class title ].

	flagsList
		displayBlock: [ :flag | flag parameter asString , ' (' , flag locations size asString , ' occurences)' ];
		sortingBlock: [ :flag | flag parameter asString ] ascending.

	locationsTable
		activateOnDoubleClick;
		whenActivatedDo: [ :selection | selection selectedItem openInBrowser ];
		addColumn: (StringTableColumn title: 'Class' evaluated: #classLocation);
		addColumn: (StringTableColumn title: 'Method' evaluated: #selector);
		contextMenu: self tableMenu.

	code aboutToStyle: true
]

{ #category : #accessing }
FBByFlagsPagePresenter >> locationsTable [
	^ locationsTable
]

{ #category : #accessing }
FBByFlagsPagePresenter >> locationsTable: anObject [
	locationsTable := anObject
]

{ #category : #accessing }
FBByFlagsPagePresenter >> modeDropbox [
	^ modeDropbox
]

{ #category : #accessing }
FBByFlagsPagePresenter >> modeDropbox: anObject [
	modeDropbox := anObject
]

{ #category : #accessing }
FBByFlagsPagePresenter >> selectedMode [
	^ selectedMode
]

{ #category : #accessing }
FBByFlagsPagePresenter >> selectedMode: anObject [
	selectedMode := anObject.
	self flagsList
		ifNotNil: [ :list | 
			list
				items: selectedMode allFlags;
				selectIndex: 1 ]
]

{ #category : #initialization }
FBByFlagsPagePresenter >> tableMenu [
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
