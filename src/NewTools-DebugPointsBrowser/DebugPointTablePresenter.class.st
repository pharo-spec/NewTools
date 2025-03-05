"
I am a table presenter for debug points with a custom context menu to perform several actions (browse, inspect, ...).
"
Class {
	#name : 'DebugPointTablePresenter',
	#superclass : 'SpTablePresenter',
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'browsing' }
DebugPointTablePresenter >> browseInstanceVariable: anInstVarName fromClass: aClass [

	(self application tools browser openOnClass: aClass)
		switchToVariables;
		selectVariableNamed: anInstVarName
]

{ #category : 'browsing' }
DebugPointTablePresenter >> browseTarget: aDebugPointTarget [

	aDebugPointTarget browseFrom: self
]

{ #category : 'context menu' }
DebugPointTablePresenter >> debugPointActions [

	^ SpActionGroup new 
		addActionWith: [ :anItem | anItem
			name: 'Inspect';
			description: 'inspect this debug point';
			actionEnabled: [ self selectedItem isNotNil ];
			action: [ self selectedItem inspect ] ];
		addActionWith: [ :anItem | anItem
			name: 'Browse Target';
			description: 'browse target of the selected debug point';
			actionEnabled: [ self selectedItem isNotNil ];
			action: [ self browseTarget: self selectedItem target ] ];
		addActionWith: [ :anItem | anItem
			name: 'Inspect Current Scope';
			description: 'inspect the current scope of the selected debug point';
			actionEnabled: [ self selectedItem isNotNil ];
			action: [ self selectedItem scope inspect ] ];
		addActionWith: [ :anItem | anItem
			name: 'Reset Current Scope';
			description: 'resetting the current scope of the selected debug point';
			actionEnabled: [ self selectedItem isNotNil ];
			action: [ self selectedItem resetObjectScope ] ];
		addActionWith: [ :anItem | anItem
			name: 'Remove';
			description: 'removes the selected debug point';
			actionEnabled: [ self selectedItem isNotNil ];
			action: [
				self selectedItem remove.
				self refresh ] ];
		addGroupWith: [ :aGroup | aGroup 
			addActionWith: [ :anItem | anItem
				  name: 'Refresh';
				  description: 'refresh this window';
				  action: [ self refresh ] ] ]
]

{ #category : 'initialization' }
DebugPointTablePresenter >> initialize [

	super initialize.
	self initializeDebugPointTable 
]

{ #category : 'initialization' }
DebugPointTablePresenter >> initializeDebugPointTable [

	self beResizable.
	self
		addColumn:
			((SpCheckBoxTableColumn
				  title: ' '
				  evaluated: [ :item | item enabled ])
				 onActivation: [ :item | item enabled: true ];
				 onDeactivation: [ :item | item enabled: false ];
				 width: 20;
				 yourself);
		addColumn:
			((SpStringTableColumn
				  title: 'Type'
				  evaluated: [ :item | item type ])
				 width: 80;
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: 'Target'
				  evaluated: [ :item | item targetString ])
				 width: 180;
				 yourself);
		addColumn:
			((SpStringTableColumn
				  title: 'Name'
				  evaluated: [ :item | item name ])
				 beEditable;
				 onAcceptEdition: [ :item :newName | item name: newName asSymbol ]);
		addColumn: (SpStringTableColumn
				 title: 'Scope'
				 evaluated: [ :item | item scopeString ]);
		actions: self debugPointActions.
	self items: DebugPoint all asOrderedCollection.

	self dropEnabled: true.
	self dragEnabled: true.
	self wantsDrop: [ :item |
		item row ~= 0 and: [ item passenger first isKindOf: DebugPoint ] ].
	self acceptDrop: [ :item |
		item passenger first addBehavior: ChainBehavior new.
		(self itemAt: item row) addBehavior: ChainBehavior new.
		((self itemAt: item row) getBehavior: ChainBehavior) putChild:
			item passenger first ]
]
