Extension { #name : #MetacelloProjectReferenceSpec }

{ #category : #'*NewTools-Inspector-Extensions' }
MetacelloProjectReferenceSpec >> inspectionProject [
	<inspectorPresentationOrder: 910 title: 'Project'>
	| specs loadedSpecs |
	
	specs := self projectReference version spec packageSpecsInLoadOrder.
	loadedSpecs := self projectReference loads 
		ifNotEmpty: [ :loads | specs select: [ :each | loads includes: each name ] ]
		ifEmpty: [ specs ].
	
	^ SpTablePresenter new
		addColumn: (SpStringTableColumn 
			title: 'Type' 
			evaluated: [ :aSpec | aSpec type ]) 
			beNotExpandable;
		addColumn: (SpStringTableColumn 
			title: 'Name' 
			evaluated: [ :aSpec | aSpec name ]);
		items: (loadedSpecs sorted: #type ascending, #name ascending);
		yourself
	
]

{ #category : #'*NewTools-Inspector-Extensions' }
MetacelloProjectReferenceSpec >> inspectionRecord [
	<inspectorPresentationOrder: 920 title: 'Record'>
	| specs |
	
	specs := (self project version record: self projectReference loads) spec packageSpecsInLoadOrder.
	specs := specs reject: [ :each | each name = self name ].
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
MetacelloProjectReferenceSpec >> type [
	
	^ 'project'
]
