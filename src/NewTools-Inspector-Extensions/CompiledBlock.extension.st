Extension { #name : #CompiledBlock }

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledBlock >> inspectionSource [
	<inspectorPresentationOrder: 20 title: 'Method Source'>
	
	^ self method inspectionSource
		addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
			interval: (self sourceNode sourceInterval first to: self sourceNode sourceInterval last + 1));
		yourself
]
