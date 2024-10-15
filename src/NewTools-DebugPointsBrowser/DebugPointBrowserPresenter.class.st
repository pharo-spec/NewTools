"
I am the UI for the complete DebugPoint Browser, used to visualize and configure debug points and their behaviors.
"
Class {
	#name : 'DebugPointBrowserPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'dpTable',
		'dpEditor',
		'dpCode',
		'inputFilter',
		'selectAllCheckbox',
		'variableTargetPresenter',
		'targetContainer'
	],
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'world menu' }
DebugPointBrowserPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Debug Point Browser')
		parent: #Debug;
		action: [ self new open ];
		order: -3;
		help: 'opens a browser to visualize and configure debug points';
		icon: (self iconNamed: #bug)
]

{ #category : 'instance creation' }
DebugPointBrowserPresenter class >> openOn: aDebugPoint [

	self new
		select: aDebugPoint;
		open
]

{ #category : 'action handling' }
DebugPointBrowserPresenter >> activateAllDebugPoints [

	dpTable items do: [ :debugPoint |
		self activateDebugPoint: debugPoint ]
]

{ #category : 'action handling' }
DebugPointBrowserPresenter >> activateDebugPoint: debugPoint [

	(debugPoint getBehavior: ChainBehavior)
		ifNil: [ debugPoint enabled: true ]
		ifNotNil: [ debugPoint resetChain ]
]

{ #category : 'initialization' }
DebugPointBrowserPresenter >> connectPresenters [

	inputFilter whenSubmitDo: [ :text |
		self items: DebugPoint all asOrderedCollection ].
	selectAllCheckbox
		whenActivatedDo: [ self activateAllDebugPoints ];
		whenDeactivatedDo: [ self deactivateAllDebugPoints ]
]

{ #category : 'action handling' }
DebugPointBrowserPresenter >> deactivateAllDebugPoints [

	dpTable items do: [ :debugPoint |
		self deactivateDebugPoint: debugPoint ]
]

{ #category : 'action handling' }
DebugPointBrowserPresenter >> deactivateDebugPoint: debugPoint [

	debugPoint enabled: false
]

{ #category : 'layout' }
DebugPointBrowserPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: selectAllCheckbox expand: false;
				   add: inputFilter;
				   yourself)
		  expand: false;
		  add: (SpPanedLayout newLeftToRight
				   add: targetContainer;
				   add: dpEditor;
				   positionOfSlider: 50 percent;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
DebugPointBrowserPresenter >> initialize [

	super initialize.
	self class codeSupportAnnouncer weak
		when: DebugPointAdded send: #updateTable to: self;
		when: DebugPointRemoved send: #updateTable to: self;
		when: DebugPointChanged send: #updateEditor to: self
]

{ #category : 'initialization' }
DebugPointBrowserPresenter >> initializePresenters [

	self initializeTable.
	dpEditor := DebugPointEditorPresenter new.
	dpCode := DebugPointCodePresenter new editable: false.

	inputFilter := self newSearchInput
		               placeholder: 'Search by name';
		               yourself.
	selectAllCheckbox := self newCheckBox
		                     label: '(De)activate all';
		                     yourself.
	self initializeVariableTargetPresenter.

	targetContainer := SpPanedLayout newTopToBottom
		                   add: dpTable;
		                   add: dpCode;
		                   positionOfSlider: 40 percent;
		                   yourself
]

{ #category : 'presenter building' }
DebugPointBrowserPresenter >> initializeTable [

	dpTable := self instantiate: DebugPointTablePresenter.

	dpTable whenSelectionChangedDo: [ :sel |
		dpEditor debugPoint: dpTable selectedItem.
		dpTable selectedItem ifNotNil: [ :dp |
			dp updateDebugPointUIManager: self ] ]
]

{ #category : 'presenter building' }
DebugPointBrowserPresenter >> initializeVariableTargetPresenter [

	variableTargetPresenter := DebugPointVariableTargetPresenter new
]

{ #category : 'initialization' }
DebugPointBrowserPresenter >> initializeWindow: aWindowPresenter [
	
	aWindowPresenter
		title: 'Debug Point Browser';		
		windowIcon: (self application iconNamed: #bug);
		initialExtent: 800@550
]

{ #category : 'api' }
DebugPointBrowserPresenter >> items: aDebugPointCollection [

	dpTable items: (aDebugPointCollection select: [ :db |
			 db name beginsWith: inputFilter text ])
]

{ #category : 'enumerating' }
DebugPointBrowserPresenter >> select: aDebugPoint [
	dpTable selectItem: aDebugPoint 
]

{ #category : 'layout' }
DebugPointBrowserPresenter >> switchToNodeTargetView [

	self switchToTargetView: dpCode
]

{ #category : 'private - layout' }
DebugPointBrowserPresenter >> switchToTargetView: aDebugPointTargetPresenter [

	targetContainer replaceSecond: aDebugPointTargetPresenter
]

{ #category : 'layout' }
DebugPointBrowserPresenter >> switchToVariableTargetView [

	self switchToTargetView: variableTargetPresenter
]

{ #category : 'updating - presenters' }
DebugPointBrowserPresenter >> updateCode: aDebugPointTarget [

	dpCode updateCode: aDebugPointTarget
]

{ #category : 'updating - presenters' }
DebugPointBrowserPresenter >> updateEditor [
	dpTable refresh.
	dpEditor updateAll .

	
]

{ #category : 'updating - presenters' }
DebugPointBrowserPresenter >> updateTable [
	| prevSel |
	prevSel := dpTable selectedItem.
	dpTable items: DebugPoint all asOrderedCollection .
	dpTable selectItem: prevSel.

	
]

{ #category : 'updating - presenters' }
DebugPointBrowserPresenter >> updateVariableTargetPresenterFrom: aDebugPointTarget [

	variableTargetPresenter target: aDebugPointTarget
]
