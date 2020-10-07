Extension { #name : #SpMorphicTableCellBuilder }

{ #category : #'*NewTools-Debugger' }
SpMorphicTableCellBuilder >> visitVariableTagColumn: aTableColumn [
	| presenter morph |
	
	presenter := SpLinkPresenter new
		label: (aTableColumn readObject: self item);
		yourself.
	presenter color: (self item debuggerColor).
	
	presenter action: [aTableColumn applyFilterFrom: self item variableTag].

	morph := presenter buildWithSpec.
	presenter adapter applyStyle: morph.

	self 
		addCellMorph: morph
		column: aTableColumn 
]
