Extension { #name : #SymbolicBytecode }

{ #category : #'*NewTools-Inspector-Extensions' }
SymbolicBytecode >> inspectionSourceCode [
	<inspectorPresentationOrder: 30 title: 'Source'>

	^ SpCodePresenter new 
		beForBehavior: self method methodClass;
		text: self method sourceCode;
		addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
			interval: (self sourceInterval first to: self sourceInterval last + 1);
			yourself);
		yourself
]
