Extension { #name : 'Context' }

{ #category : '*NewTools-Inspector-Extensions' }
Context >> inspectionSource [
	<inspectorPresentationOrder: 910 title: 'Method Source'>

	^ self sourceNode inspectionSource
]
