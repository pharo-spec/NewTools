Extension { #name : 'OCIRMethod' }

{ #category : '*NewTools-Inspector-Extensions' }
OCIRMethod >> inpectionIr [
	<inspectorPresentationOrder: 40 title: 'Symbolic'>

	^ SpTextPresenter new 
		text: (self ir longPrintString trimmed);
		yourself
]
