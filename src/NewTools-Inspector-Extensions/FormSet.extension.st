Extension { #name : 'FormSet' }

{ #category : '*NewTools-Inspector-Extensions' }
FormSet >> inspectionFormSet: aBuilder [
	<inspectorPresentationOrder: 0 title: 'FormSet'>
	
	^ aBuilder newMorph 
		morph: self asMorph;
		yourself
]
