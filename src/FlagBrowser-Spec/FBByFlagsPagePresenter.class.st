"
Description
--------------------

I am a page presenter to show the flags grouped by their parameters. 

The user will need to select a flag parameter and see all the locations with this parameter.

I will show different mode to browse the flags depending on the kin of their parameter. (Symbol, String, Object, Anyone)
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	flagsList:		<aListPresenter>		A list displaying the differents parameters possible.
	modeDropbox:		<aDropListPresenter>	A drop list to select the parameter kinds to show.

"
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
