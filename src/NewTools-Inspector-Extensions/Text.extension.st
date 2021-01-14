Extension { #name : #Text }

{ #category : #'*NewTools-Inspector-Extensions' }
Text >> inspectionText [
	<inspectorPresentationOrder: 0 title: 'Text'>

	^ SpMorphPresenter new 
		morph: self asMorph asReadOnlyMorph;
		yourself
]
