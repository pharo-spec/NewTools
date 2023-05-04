Extension { #name : #Bag }

{ #category : #'*NewTools-Inspector-Extensions' }
Bag >> inspectionItems: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Items'> 

	^ aBuilder newTable		
		addColumn: (SpStringTableColumn new 
			title: 'Items';
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each key ];
			beNotExpandable;
			beSortable;
			yourself);
		addColumn: (SpStringTableColumn new  
			title: 'Occurences'; 
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: (self occurrencesOf: each key) ];
			beSortable;
			yourself);
		items: contents associations;
		yourself
]
