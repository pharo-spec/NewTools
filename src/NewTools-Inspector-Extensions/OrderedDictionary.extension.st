Extension { #name : 'OrderedDictionary' }

{ #category : '*NewTools-Inspector-Extensions' }
OrderedDictionary >> inspectionItems: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Items'>
	^ aBuilder newTable
		addStyle: 'stList';
		addColumn: (SpStringTableColumn new
			title: 'Key';
			evaluated: [ :each | each key ];
			formatted: [ :key | StObjectPrinter asTruncatedTextFrom: key ];
			beSortable);
		addColumn: (SpStringTableColumn new
			title: 'Value';
			evaluated: [ :each | each value ];
			formatted: [ :value |
			   StObjectPrinter asTruncatedTextFrom: value ];
			beSortable);
		items: (self associations collect: [ :e | StInspectorAssociationNode hostObject: e ]);
		yourself
]
