Extension { #name : 'MetaLink' }

{ #category : '*NewTools-Inspector-Extensions' }
MetaLink >> inpectionDefiniton: aBuilder [
	<inspectorPresentationOrder: 920 title: 'Definition'>
	
	^ aBuilder newText 
		text: self definitionString;
		yourself
]
