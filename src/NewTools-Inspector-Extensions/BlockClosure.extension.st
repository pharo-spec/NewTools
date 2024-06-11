Extension { #name : 'BlockClosure' }

{ #category : '*NewTools-Inspector-Extensions' }
BlockClosure >> inpectionIr [
	<inspectorPresentationOrder: 35 title: 'IR'>

	^ self method ir inpectionIr
]

{ #category : '*NewTools-Inspector-Extensions' }
BlockClosure >> inspectionAST [
	<inspectorPresentationOrder: 35 title: 'AST'>

	^ self sourceNode inspectionAST
]

{ #category : '*NewTools-Inspector-Extensions' }
BlockClosure >> inspectionSource [
	<inspectorPresentationOrder: 30 title: 'Method Source'>

	^ self sourceNode inspectionSource
]
