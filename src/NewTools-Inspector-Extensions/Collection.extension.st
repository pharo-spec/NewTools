Extension { #name : 'Collection' }

{ #category : '*NewTools-Inspector-Extensions' }
Collection >> inspectionItems: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Items'> 
	
	^ aBuilder newTable
		addStyle: 'stList';
		addColumn: (SpIndexTableColumn new 
			title: 'Index';
			sortFunction: #yourself ascending;
			beNotExpandable;
			yourself);
		addColumn: (SpStringTableColumn new  
			title: 'Value'; 
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each ];
			beSortable;
			yourself);
		items: self asOrderedCollection;
		yourself
]
