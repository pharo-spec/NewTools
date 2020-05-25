"
Lists all the debuggers available in the image, along with their rank (provided they always return the same rank regardless of the debug session). Also list all the debug sessions stored in DebugSessionStorage.
"
Class {
	#name : #DebuggerSelectorBrowser,
	#superclass : #SpPresenter,
	#instVars : [
		'debuggerListToolBar',
		'debuggerTable'
	],
	#category : #'NewTools-DebuggerSelector-Browser'
}

{ #category : #specs }
DebuggerSelectorBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #debuggerListToolBar withConstraints: [ :cstr | cstr height: 35 ];
		add: #debuggerTable;
		yourself
]

{ #category : #specs }
DebuggerSelectorBrowser class >> initialExtent [
	^ 750@350
]

{ #category : #'world menu' }
DebuggerSelectorBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'List Debuggers and Debug Sessions')
		parent: #Debugging;
		order: 3;
		help: 'Shows the list all available debuggers in the image, and all the stored debug sessions. Allows to open stored debug sessions with any debugger';
		iconName: #glamorousTable;
		action: [ self open ]
]

{ #category : #api }
DebuggerSelectorBrowser class >> open [
	<example>
	self new openWithSpec
]

{ #category : #specs }
DebuggerSelectorBrowser class >> title [
	^ 'Available Debuggers'
]

{ #category : #deprecated }
DebuggerSelectorBrowser >> addCorrectMainDebuggerButtonToToolBar: aToolBar [
	debuggerTable selectedItems
		ifNotEmpty: [ :debuggerList_ | 
			OldDebuggerSelector singleton mainDebuggerClass == (debuggerList_ at: 1)
				ifTrue:
					[ "A debugger is selected in the list, and it is the main debugger class, so we add a button allowing the user to remove this debugger from the main debugger class"
					aToolBar
						addItem:
							((self instantiate: SpToolBarButtonPresenter)
								label: 'Main Debugger';
								icon: (self iconNamed: #checkboxSelected);
								action: [ OldDebuggerSelector singleton setNoMainDebuggerClass.
									self updateDebuggerTable.
									self refreshDebuggerListToolBar ];
								help: 'Set this debugger to no longer be the main debugger').
					^ self ] ].

	"Otherwise (no debugger is selected, or a debugger is selected and it is not the main debugger class), we add a buttont allowing to set the selected debugger as main debugger"
	aToolBar
		addItem:
			((self instantiate: SpToolBarButtonPresenter)
				label: 'Main Debugger';
				icon: (self iconNamed: #checkboxUnselected);
				action: [ debuggerTable selectedItems
						ifEmpty: [ self inform: 'You need to select a debugger' ]
						ifNotEmpty:
							[ :debuggerList_ | OldDebuggerSelector singleton mainDebuggerClass: (debuggerList_ at: 1) ].
					self updateDebuggerTable.
					self refreshDebuggerListToolBar ];
				help: 'Set this debugger to be the main debugger')
]

{ #category : #initialization }
DebuggerSelectorBrowser >> initializeDebuggerTable [
	debuggerTable := self newTable
		addColumn:
			(SpStringTableColumn
				title: 'Debugger'
				evaluated: [ :debuggerClass | debuggerClass key ]);
		addColumn:
			(SpStringTableColumn
				title: 'Rank'
				evaluated: [ :aDebuggerClass | aDebuggerClass value ]);
		yourself
]

{ #category : #initialization }
DebuggerSelectorBrowser >> initializePresenters [
	super initializePresenters.
	self initializeDebuggerTable.
	debuggerListToolBar := self newToolBar.
	self updateDebuggerTable
]

{ #category : #deprecated }
DebuggerSelectorBrowser >> refreshDebuggerListToolBar [
	debuggerListToolBar removeAllItems.
	debuggerListToolBar
		addItem:
			((self instantiate: SpToolBarButtonPresenter)
				label: 'Browse';
				icon: (self iconNamed: #smallFind);
				action: [ debuggerTable selectedItems
						ifEmpty: [ self inform: 'You need to select a debugger' ]
						ifNotEmpty:
							[ :debuggerList_ | (debuggerList_ at: 1) browse switchToMetaLevelScope: ClyClassSideScope ] ]);
		help: 'Browse the class of the selected debugger'.
	self addCorrectMainDebuggerButtonToToolBar: debuggerListToolBar
]

{ #category : #refresh }
DebuggerSelectorBrowser >> updateDebuggerTable [
	debuggerTable items: DebuggerSelector availableDebuggers
]
