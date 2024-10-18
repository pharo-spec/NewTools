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
		roots: self inspectorNodes;
		children: [ :node | #() ]
]

{ #category : '*NewTools-Debugger' }
StRawInspectionPresenter >> selectedPageName [

	^'Context'
]

{ #category : '*NewTools-Debugger' }
StRawInspectionPresenter >> updateNodesFromScope: oldASTScope to: newASTScope [

	| nodes newTemps oldTemps tempsToRemove tempsToAdd |
	oldTemps := oldASTScope allTemps.
	newTemps := newASTScope allTemps.
	tempsToRemove := oldTemps difference: newTemps.
	tempsToAdd := newTemps difference: oldTemps.
	nodes := self attributeTable roots.

	nodes removeAllSuchThat: [ :node |
		node class = StInspectorTempNode and: [
			tempsToRemove includes: node tempVariable ] ].
	tempsToAdd do: [ :temp |
		nodes add:
			((StInspectorTempNode hostObject:
					  self model inspectedObject context)
				 tempVariable: temp;
				 yourself) ].

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
