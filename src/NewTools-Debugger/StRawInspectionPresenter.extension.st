Extension { #name : 'StRawInspectionPresenter' }

{ #category : '*NewTools-Debugger' }
StRawInspectionPresenter >> activePresenter [
	^self
]

{ #category : '*NewTools-Debugger' }
StRawInspectionPresenter >> addVariableTagColumn [

	attributeTable addColumn: self variableTagColumn
]

{ #category : '*NewTools-Debugger' }
StRawInspectionPresenter >> attributeTable [

	^attributeTable
]

{ #category : '*NewTools-Debugger' }
StRawInspectionPresenter >> beForDebugger [

	attributeTable := (self instantiate: StDebuggerTreeTablePresenter)
		beResizable;
		actions: self rootCommandsGroup;
		yourself.
		
	StInspectorPresenter inspectorDiveOnSingleClick
		ifTrue: [ attributeTable activateOnSingleClick ].
	
	self addVariableTagColumn.
	self addVariablesColumn.
	self addValuesColumn.	

	attributeTable
		roots: self modelInspectorNodes;
		children: [ :node | #() ]
]

{ #category : '*NewTools-Debugger' }
StRawInspectionPresenter >> selectedPageName [

	^'Context'
]

{ #category : '*NewTools-Debugger' }
StRawInspectionPresenter >> updateNodesFromScope: oldTemps to: newTemps [
	"Update the temporary nodes to the variables visible in the new scope. The kept nodes forget their display strings, since the debugger keeps them while stepping and their values may have changed."

	| nodes tempsToRemove tempsToAdd |
	tempsToRemove := oldTemps difference: newTemps.
	tempsToAdd := newTemps difference: oldTemps.
	nodes := self attributeTable roots.
	nodes removeAllSuchThat: [ :node | node class = StInspectorTempNode and: [ tempsToRemove includes: node tempName ] ].
	nodes do: [ :node | node resetStringValue ].
	nodes addAll: (tempsToAdd collect: [ :temp |
		 (StInspectorTempNode hostObject: self model inspectedObject context)
			 tempName: temp;
			 yourself ]).

	self attributeTable roots: nodes
]

{ #category : '*NewTools-Debugger' }
StRawInspectionPresenter >> variableTagColumn [

	^  SpLinkTableColumn new 
		title: 'Type';
		width: 70;
		evaluated: [ :aNode | aNode variableTag ];
		action: [ :aNode |  attributeTable toggleFilter: aNode variableTag. owner updateHeaderBar. ];
		sortFunction: #variableTag ascending;
		yourself
]
