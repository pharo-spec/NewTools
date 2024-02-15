"
I am a table presenter for debug points with a custom context menu to perform several actions (browse, inspect, ...).
"
Class {
	#name : 'DebugPointTablePresenter',
	#superclass : 'SpTablePresenter',
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'context menu' }
DebugPointTablePresenter >> debugPointContextMenu [

	^ self newMenu
		  addGroup: [ :aGroup |
			  aGroup
				  addItem: [ :anItem |
					  anItem
						  name: 'Inspect';
						  description: 'inspect this debug point';
						  enabled: [ self selectedItem isNotNil ];
						  action: [ self selectedItem inspect ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'Browse Target';
						  description: 'browse target of the selected debug point';
						  enabled: [ self selectedItem isNotNil ];
						  action: [ self selectedItem browse ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'Inspect Current Scope';
						  description:
							  'inspect the current scope of the selected debug point';
						  enabled: [ self selectedItem isNotNil ];
						  action: [ self selectedItem scope inspect ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'Reset Current Scope';
						  description:
							  'resetting the current scope of the selected debug point';
						  enabled: [ self selectedItem isNotNil ];
						  action: [ self selectedItem resetObjectScope ] ];
				  addItem: [ :anItem |
					  anItem
						  name: 'Remove';
						  description: 'removes the selected debug point';
						  enabled: [ self selectedItem isNotNil ];
						  action: [
							  self selectedItem remove.
							  self refresh ] ] ];
		  addGroup: [ :aGroup |
			  aGroup addItem: [ :anItem |
				  anItem
					  name: 'Refresh';
					  description: 'refresh this window';
					  action: [ self refresh ] ] ]
]

{ #category : 'initialization' }
DebugPointTablePresenter >> initialize [ 
	super initialize.
	self initializeDebugPointTable 
]

{ #category : 'presenter building' }
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
		addColumn:
		(SpStringTableColumn
			 title: 'Scope'
			 evaluated: [ :item | item scope ]);
		contextMenu: self debugPointContextMenu.
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
