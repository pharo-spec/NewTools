Extension { #name : #BaselineOf }

{ #category : #'*NewTools-Inspector-Extensions' }
BaselineOf >> inspectionSpec [
	<inspectorPresentationOrder: 910 title: 'Spec'>
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
