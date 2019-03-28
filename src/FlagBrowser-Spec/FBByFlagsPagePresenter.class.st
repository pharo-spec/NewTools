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
	#superclass : #FBFlagPresentationPresenter,
	#instVars : [
		'modeDropbox',
		'flagsList',
		'caseCheckbox'
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
		add: #caseCheckbox withConstraints: [ :constraints | constraints height: 20 ];
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
	
	self transmit
		from: flagsList
		to: locationsTable
		transform: #locations
		postTransmission: [ :destination | destination selectIndex: 1 ].

	self transmit from: modeDropbox to: flagsList transform: #allFlags postTransmission: [ :destination | destination selectIndex: 1 ].

	modeDropbox selectedItem: FBSymbolFlag.

	caseCheckbox
		whenChangedDo: [ :value | 
			FBFlag caseSensitive: value.
			modeDropbox selectedItem: modeDropbox selectedItem	"Used to refresh the list" ]
]

{ #category : #initialization }
FBByFlagsPagePresenter >> initializeWidgets [
	super initializeWidgets.
	modeDropbox := self newDropList.
	flagsList := self newList.
	caseCheckbox := self newCheckBox.

	modeDropbox
		items: FBFlag withAllSubclasses;
		displayBlock: [ :class | class title ].

	flagsList
		displayBlock: [ :flag | flag parameter asString , ' (' , flag locations size asString , ' occurences)' ];
		sortingBlock: [ :flag | flag parameter asString ] ascending.

	locationsTable
		addColumn: (StringTableColumn title: 'Class' evaluated: #classLocation);
		addColumn: (StringTableColumn title: 'Method' evaluated: #selector).

	caseCheckbox
		label: 'Case sensitive';
		state: FBFlag caseSensitive
]

{ #category : #accessing }
FBByFlagsPagePresenter >> modeDropbox [
	^ modeDropbox
]

{ #category : #accessing }
FBByFlagsPagePresenter >> modeDropbox: anObject [
	modeDropbox := anObject
]
