Extension { #name : 'Variable' }

{ #category : '*NewTools-Inspector-Extensions' }
Variable >> inspectionUsingMethods: aBuilder [
	<inspectorPresentationOrder: 920 title: 'Using Methods'>
	| usingMethods |
	
	usingMethods := self usingMethods sort: [ :x :y | x name < y name ].

	^ aBuilder newList
		addStyle: 'stList';
		items: usingMethods;
		display: #name;
		yourself
]
