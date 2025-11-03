Extension { #name : 'OCIRMethod' }

{ #category : '*NewTools-Inspector-Extensions' }
OCIRMethod >> inpectionIr: aBuilder [
	<inspectorPresentationOrder: 40 title: 'Symbolic'>

	^ aBuilder newCode
		withoutSyntaxHighlight;
		text: (self ir longPrintString trimmed);
		yourself
]
