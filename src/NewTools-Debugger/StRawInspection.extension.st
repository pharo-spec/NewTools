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
		                  activateOnSingleClick;
		                  beResizable;
		                  contextMenu: [ 
			                  self rootCommandsGroup asMenuPresenter ];
		                  yourself.
	self addVariableTagColumn.
	self addVariablesColumn.
	self addValuesColumn.
	attributeTable
		roots: self inspectorNodes;
		children: [ :node | #(  ) ]
]

{ #category : #'*NewTools-Debugger' }
StRawInspection >> selectedPageName [
	^'Context'
]

{ #category : #'*NewTools-Debugger' }
StRawInspection >> variableTagColumn [

	^ SpCompositeTableColumn new
		  title: 'tag';
		  width: 70;
		  addColumn: ((StVariableTagColumn on: attributeTable)
				   evaluated: #variableTag;
				   yourself);
		  sortFunction: #variableTag ascending;
		  yourself
]
