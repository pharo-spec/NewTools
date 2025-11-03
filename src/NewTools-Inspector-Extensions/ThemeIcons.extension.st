Extension { #name : 'ThemeIcons' }

{ #category : '*NewTools-Inspector-Extensions' }
ThemeIcons >> inspectionIcons: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Icons'>
	
	^ aBuilder newTable
		addStyle: 'stList';
		addColumn: ((SpImageTableColumn 
			title: 'Icon'
			evaluated: [ :aSpec | aSpec value ])
			width: 50);
		addColumn: (SpStringTableColumn 
			title: 'Symbol' 
			evaluated: [ :aSpec | aSpec key ]);  	 
		items: (self icons associations sorted: #key ascending);
		yourself
]
