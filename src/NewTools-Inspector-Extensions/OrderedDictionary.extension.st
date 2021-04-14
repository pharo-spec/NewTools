Extension { #name : #OrderedDictionary }

{ #category : #'*NewTools-Inspector-Extensions' }
OrderedDictionary >> inspectionItems: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Items'> 
	
	^ aBuilder newTable 
		addColumn: (SpStringTableColumn 
			title: 'Key'
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each key ]);
		addColumn: (SpStringTableColumn 
			title: 'Value' 
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each value ]);
		items: self associations;
		yourself
]
