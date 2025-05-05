Extension { #name : 'Pragma' }

{ #category : '*NewTools-Inspector-Extensions' }
Pragma >> inspectionSourceCodeMethod [
	<inspectorPresentationOrder: 30 title: 'Method'>
	| interval |
	
	interval := self sourceNode sourceInterval.
	^ SpCodePresenter new 
		beForMethod: method ast;
		text: method sourceCode;
		addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
			interval: (interval first to: interval last + 1);
			yourself);
		yourself
]
