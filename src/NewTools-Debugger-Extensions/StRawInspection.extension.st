Extension { #name : #StRawInspection }

{ #category : #'*NewTools-Debugger-Extensions' }
StRawInspection >> addVariableTagColumn [

	attributeTable addColumn: self variableTagColumn
]

{ #category : #'*NewTools-Debugger-Extensions' }
StRawInspection >> attributeTable [

	^attributeTable
]

{ #category : #'*NewTools-Debugger-Extensions' }
StRawInspection >> beForDebugger [

	attributeTable := self newTreeTable
		                  activateOnSingleClick;
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

{ #category : #'*NewTools-Debugger-Extensions' }
StRawInspection >> variableTagColumn [

	^ SpCompositeTableColumn new
		  title: 'tag';
		  width: 70;
		  addColumn: (SpStringTableColumn new
				   evaluated: #variableTag;
				   yourself);
		  sortFunction: #variableTag ascending;
		  yourself
]
