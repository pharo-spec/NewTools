Extension { #name : #BaselineOf }

{ #category : #'*NewTools-Inspector-Extensions' }
BaselineOf >> inspectionProject [
	<inspectorPresentationOrder: 10 title: 'Project'>
	| specs |
	
	specs := self project version spec packageSpecsInLoadOrder.
	^ SpTablePresenter new
		addColumn: (SpStringTableColumn 
			title: 'Type' 
			evaluated: [ :aSpec | aSpec type ]) 
			beNotExpandable;
		addColumn: (SpStringTableColumn 
			title: 'Name' 
			evaluated: [ :aSpec | aSpec name ]);
		items: (specs sorted: #type ascending, #name ascending);
		yourself
]

{ #category : #'*NewTools-Inspector-Extensions' }
BaselineOf >> inspectionRecord [
	<inspectorPresentationOrder: 20 title: 'Record'>
	| specs |
	
	specs := self project version record spec packageSpecsInLoadOrder.
	^ SpTablePresenter new
		addColumn: (SpStringTableColumn 
			title: 'Type' 
			evaluated: [ :aSpec | aSpec type ]) 
			beNotExpandable;
		addColumn: (SpStringTableColumn 
			title: 'Name' 
			evaluated: [ :aSpec | aSpec name ]);
		items: (specs sorted: #type ascending, #name ascending);
		yourself
]
