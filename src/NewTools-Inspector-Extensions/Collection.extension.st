Extension { #name : #Collection }

{ #category : #'*NewTools-Inspector-Extensions' }
Collection >> inspectorItems [
	<inspectorPresentationOrder: 0 title: 'Items'> 
	
	^ SpTablePresenter new 
		addColumn: (SpIndexTableColumn title: 'Index');
		addColumn: (SpStringTableColumn 
			title: 'Value' 
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each ]);
		items: self asOrderedCollection;
		yourself
]
