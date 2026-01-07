Extension { #name : 'MetacelloMemberListSpec' }

{ #category : '*NewTools-Inspector-Extensions' }
MetacelloMemberListSpec >> inspectionMap: aBuilder [

	<inspectorPresentationOrder: 901 title: 'Specs'>
	^ aBuilder newTable
		  beResizable;
		  items: self map associations;
		  addColumn: (SpStringTableColumn new
				   title: 'Spec name';
				   width: 300;
				   beSortable;
				   evaluated: [ :each | each key ]);
		  addColumn: (SpStringTableColumn new
				   title: 'Kind';
				   width: 100;
				   beSortable;
				   evaluated: [ :each | (each value class name withoutPrefix: 'Metacello') withoutSuffix: 'Spec' ]);
		  addColumn: (SpStringTableColumn new
				   title: 'Spec';
				   beSortable;
				   evaluated: [ :each | each value ]);
		  yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
MetacelloMemberListSpec >> inspectionMembers: aBuilder [

	<inspectorPresentationOrder: 902 title: 'Operations'>
	^ aBuilder newTable
		  beResizable;
		  items: self list;
		  addColumn: (SpStringTableColumn new
				   title: 'Name';
				   width: 300;
				   beSortable;
				   evaluated: [ :each | each name ]);
		  addColumn: (SpStringTableColumn new
				   title: 'Kind';
				   width: 100;
				   beSortable;
				   evaluated: [ :each | (each class name withoutPrefix: 'Metacello') withoutSuffix: 'MemberSpec' ]);
		  addColumn: (SpStringTableColumn new
				   title: 'Spec';
				   beSortable;
				   evaluated: [ :each | each spec ]);
		  yourself
]
