Extension { #name : 'MetacelloVersionSpec' }

{ #category : '*NewTools-Inspector-Extensions' }
MetacelloVersionSpec >> inspectionSubSpecs: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Declared specs'>
	^ aBuilder newTable
		  beResizable;
		  items: self packageSpecsInLoadOrder;
		  addColumn: (SpStringTableColumn new
				   title: 'Name';
				   width: 300;
				   beSortable;
				   evaluated: [ :each | each name ]);
		  addColumn: (SpStringTableColumn new
				   title: 'Kind';
				   width: 100;
				   beSortable;
				   evaluated: [ :each | (each class name withoutPrefix: 'Metacello') withoutSuffix: 'Spec' ]);
		  addColumn: (SpStringTableColumn new
				   title: 'Requires';
				   beSortable;
				   evaluated: [ :each | each requires ]);
		  addColumn: (SpStringTableColumn new
				   title: 'Includes';
				   beSortable;
				   evaluated: [ :each | each includes ]);
		  yourself
]
