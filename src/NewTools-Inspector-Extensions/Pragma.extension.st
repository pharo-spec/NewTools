Extension { #name : 'Pragma' }

{ #category : '*NewTools-Inspector-Extensions' }
Pragma >> inspectionSourceCodeMethod [
	<inspectorPresentationOrder: 30 title: 'Method'>

	^ SpCodePresenter new 
		beForMethod: method ast;
		text: (method sourceCode);
		addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
			interval: (self sourceNode sourceInterval first to: self sourceNode sourceInterval last + 1);
			yourself);
		yourself
]
