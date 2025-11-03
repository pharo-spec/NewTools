Extension { #name : 'SymbolicBytecode' }

{ #category : '*NewTools-Inspector-Extensions' }
SymbolicBytecode >> inspectionSource: aBuilder [
	<inspectorPresentationOrder: 30 title: 'Method Source'>

	^ aBuilder newCode 
		addStyle: 'stCode';
		beForBehavior: self method methodClass;
		text: self method sourceCode;
		addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
			interval: (self sourceInterval first to: self sourceInterval last + 1);
			yourself);
		yourself
]
