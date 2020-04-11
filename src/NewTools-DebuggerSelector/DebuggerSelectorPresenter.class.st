"
Lists all the debuggers available in the image, along with their rank (provided they always return the same rank regardless of the debug session). Also list all the debug sessions stored in DebugSessionStorage.
"
Class {
	#name : #DebuggerSelectorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'debuggerList',
		'debuggerListToolBar'
	],
	#category : #'NewTools-DebuggerSelector-Core'
}

{ #category : #specs }
DebuggerSelectorPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #debuggerListToolBar withConstraints: [ :cstr | cstr height: 35 ];
		add: #debuggerList;
		yourself
]

{ #category : #specs }
DebuggerSelectorPresenter class >> initialExtent [
	^ 750@350
]

{ #category : #'world menu' }
DebuggerSelectorPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'List Debuggers and Debug Sessions')
		parent: #Debugging;
		order: 3;
		help: 'Shows the list all available debuggers in the image, and all the stored debug sessions. Allows to open stored debug sessions with any debugger';
		iconName: #glamorousTable;
		action: [ self open ]
]

{ #category : #api }
DebuggerSelectorPresenter class >> open [
	<example>
	self new openWithSpec
]

{ #category : #specs }
DebuggerSelectorPresenter class >> title [
	^ 'Available Debuggers'
]

{ #category : #helpers }
DebuggerSelectorPresenter >> addCorrectMainDebuggerButtonToToolBar: aToolBar [
	debuggerList selectedItems
		ifNotEmpty: [ :debuggerList_ | 
			DebuggerSelector singleton mainDebuggerClass == (debuggerList_ at: 1)
				ifTrue:
					[ "A debugger is selected in the list, and it is the main debugger class, so we add a button allowing the user to remove this debugger from the main debugger class"
					aToolBar
						addItem:
							((self instantiate: SpToolBarButtonPresenter)
								label: 'Main Debugger';
								icon: (self iconNamed: #checkboxSelected);
								action: [ DebuggerSelector singleton setNoMainDebuggerClass.
									self refreshDebuggerList.
									self refreshDebuggerListToolBar ];
								help: 'Set this debugger to no longer be the main debugger').
					^ self ] ].

	"Otherwise (no debugger is selected, or a debugger is selected and it is not the main debugger class), we add a buttont allowing to set the selected debugger as main debugger"
	aToolBar
		addItem:
			((self instantiate: SpToolBarButtonPresenter)
				label: 'Main Debugger';
				icon: (self iconNamed: #checkboxUnselected);
				action: [ debuggerList selectedItems
						ifEmpty: [ self inform: 'You need to select a debugger' ]
						ifNotEmpty:
							[ :debuggerList_ | DebuggerSelector singleton mainDebuggerClass: (debuggerList_ at: 1) ].
					self refreshDebuggerList.
					self refreshDebuggerListToolBar ];
				help: 'Set this debugger to be the main debugger')
]

{ #category : #helpers }
DebuggerSelectorPresenter >> compareRank: rank1 to: rank2 [
	rank1 isInteger
		ifFalse: [ ^ false ].	"If rank1 is not an integer, (typically a string), then it is smaller than rank2"
	rank2 isInteger
		ifFalse: [ ^ true ].	"If rank2 is not an integer, (typically a string), then it is smaller than rank1"
	^ rank1 >= rank2	"Otherwise, both ranks are int, we return the result of their comparison"
]

{ #category : #helpers }
DebuggerSelectorPresenter >> debuggerClassToNameOfDebugger: aDebuggerClass [
	"Returns the name of @aDebuggerClass, to be displayed in the list of debuggers. If @aDebuggerClass is the main debugger defined in DebuggerSelector, return the name as a Text styled in bold"

	aDebuggerClass == DebuggerSelector singleton mainDebuggerClass
		ifTrue: [ ^ aDebuggerClass asString asText
				allBold;
				yourself ]
		ifFalse: [ ^ aDebuggerClass asString ]
]

{ #category : #helpers }
DebuggerSelectorPresenter >> debuggerClassToRankToDisplay: aDebuggerClass [
	"Returns what should be displayed as the rank of @aDebuggerClass.
	Since we do not have a debug session to give this debugger, we try with nil. If it answers a rank, we display it, if it raises an exception, we assume it really needed a debug session to give a rank, so we display a string explaining that.
	In addition, if @aDebuggerClass is the main debugger class (see class DebuggerSelector), then its ranks should be displayed in bold"

	| result |
	result := [ (aDebuggerClass rankDebugSession: nil) asString ]
		on: Exception
		do: [ 'Depends on the debug session' ].
	aDebuggerClass == DebuggerSelector singleton mainDebuggerClass
		ifTrue: [ ^ result asText allBold yourself ]
		ifFalse: [ ^ result ]
]

{ #category : #'presenter building' }
DebuggerSelectorPresenter >> debuggerList [
	^ self newTable
		addColumn: ((SpStringTableColumn
			title: 'Rank'
			evaluated: [ :aDebuggerClass | self debuggerClassToRankToDisplay: aDebuggerClass ])
			width: 150);
		addColumn: (SpStringTableColumn
			title: 'Debugger'
			evaluated: [ :debuggerClass | self debuggerClassToNameOfDebugger: debuggerClass ]);
		whenSelectionChangedDo: [ self refreshDebuggerListToolBar ];
		yourself
]

{ #category : #helpers }
DebuggerSelectorPresenter >> getBlockTryingToGetRankOfDebugger [
	"Returns a block taking a debugger as argument and returning the rank it would give to a nil debug session. If an exception is raised, the debugger really needs the debug session object to give a rank, so the block returns a string saying that. If no exception is raised, it means the debugger did not need an actual debug session object to answer, the block directly return the returned value"

	^ [ :aDebugger | 
	[ aDebugger rankDebugSession: nil ]
		on: Exception
		do: [ 'Depends on the debug session' ] ]
]

{ #category : #helpers }
DebuggerSelectorPresenter >> getSortingBlock [
	| rankBlock |
	rankBlock := self getBlockTryingToGetRankOfDebugger.
	^ [ :aDebuggerClass1 :aDebuggerClass2 | 
		| rank1 rank2 |
		rank1 := rankBlock value: aDebuggerClass1.
		rank2 := rankBlock value: aDebuggerClass2.
		self compareRank: rank1 to: rank2 ]
]

{ #category : #initialization }
DebuggerSelectorPresenter >> initializePresenters [
	super initializePresenters.
	debuggerList := self debuggerList.
	debuggerListToolBar := self newToolBar.

	self refreshDebuggerList.
	self refreshDebuggerListToolBar.

]

{ #category : #helpers }
DebuggerSelectorPresenter >> printDateAndTime: aDateAndTime [
	| d |
	d := aDateAndTime.
	^ ' ' , d hour asString , ':' , d minute asString , ' '
		, d year asString , '-' , d month asString , '-'
		, d dayOfMonth asString
]

{ #category : #refresh }
DebuggerSelectorPresenter >> refreshDebuggerList [
	debuggerList items:
		(DebuggerSelector singleton getDebuggerClasses
			sort: self getSortingBlock)
]

{ #category : #refresh }
DebuggerSelectorPresenter >> refreshDebuggerListToolBar [
	debuggerListToolBar removeAllItems.
	debuggerListToolBar
		addItem:
			((self instantiate: SpToolBarButtonPresenter)
				label: 'Browse';
				icon: (self iconNamed: #smallFind);
				action: [ debuggerList selectedItems
						ifEmpty: [ self inform: 'You need to select a debugger' ]
						ifNotEmpty:
							[ :debuggerList_ | (debuggerList_ at: 1) browse switchToMetaLevelScope: ClyClassSideScope ] ]);
		help: 'Browse the class of the selected debugger'.
	self addCorrectMainDebuggerButtonToToolBar: debuggerListToolBar
]

{ #category : #helpers }
DebuggerSelectorPresenter >> sortDebugSessionUnitStorage: aDebugSessionUnitStorage and: aDebugSessionUnitStorage2 [
	"Return true if @aDebugSessionUnitStorage has been stored more recently than @aDebugSessionUnitStorage2"

	^ aDebugSessionUnitStorage timeOfCreation
		>= aDebugSessionUnitStorage2 timeOfCreation
]
