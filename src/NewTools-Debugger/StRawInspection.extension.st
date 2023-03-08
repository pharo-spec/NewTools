Extension { #name : #StRawInspection }

{ #category : #'*NewTools-Debugger' }
StRawInspection >> activePresenter [
	^self
]

{ #category : #'*NewTools-Debugger' }
StRawInspection >> addVariableTagColumn [

	attributeTable addColumn: self variableTagColumn
]

{ #category : #'*NewTools-Debugger' }
StRawInspection >> attributeTable [

	^attributeTable
]

{ #category : #'*NewTools-Debugger' }
StRawInspection >> beForDebugger [

	attributeTable := (self instantiate: StDebuggerTreeTablePresenter)
		beResizable;
		contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		yourself.
		
	StInspector inspectorDiveOnSingleClick
		ifTrue: [ attributeTable activateOnSingleClick ].
	
	self addVariableTagColumn.
	self addVariablesColumn.
	self addValuesColumn.	

	attributeTable
		roots: self inspectorNodes;
		children: [ :node | #() ]
]

{ #category : #'*NewTools-Debugger' }
StRawInspection >> selectedPageName [

	^'Context'
]

{ #category : #'*NewTools-Debugger' }
StRawInspection >> updateNodesFromScope: oldASTScope to: newASTScope [

	| nodes newTemps oldTemps tempsToRemove tempsToAdd |
	1 haltOnce.
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

{ #category : #'*NewTools-Debugger' }
StRawInspection >> variableTagColumn [

	^  SpLinkTableColumn new 
		title: 'Type';
		width: 70;
		evaluated: [ :aNode | aNode variableTag ];
		action: [ :aNode |  attributeTable toggleFilter: aNode variableTag. owner updateHeaderBar. ];
		sortFunction: #variableTag ascending;
		yourself
]
