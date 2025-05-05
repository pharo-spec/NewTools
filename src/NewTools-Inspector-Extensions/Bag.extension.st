Extension { #name : 'Bag' }

{ #category : '*NewTools-Inspector-Extensions' }
Bag >> inspectionItems: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Items'>
	| sortFuction |
	sortFuction := [ :c1 :c2 | c1 value > c2 value ].

	^ aBuilder newTable
		  addColumn: (SpStringTableColumn new
				   title: 'Items';
				   evaluated: [ :each | each key ];
				   formatted: [ :each | StObjectPrinter asTruncatedTextFrom: each ];
				   beNotExpandable;
				   beSortable;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Occurences';
				   evaluated: [ :each | self occurrencesOf: each key ];
				   formatted: [ :each | StObjectPrinter asTruncatedTextFrom: each ];
				   beSortable;
				   yourself);
		  items: (contents associations sort: sortFuction);
		  yourself
]
