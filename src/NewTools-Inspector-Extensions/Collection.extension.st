Extension { #name : #Collection }

{ #category : #'*NewTools-Inspector-Extensions' }
Collection >> inspectorItems [
	<inspectorPresentationOrder: 0> 
	
	^ TablePresenter new 
		title: 'Items';
		addColumn: (IndexTableColumn title: 'Index');
		addColumn: (StringTableColumn 
			title: 'Value' 
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each ]);
		items: self asOrderedCollection;
		yourself
]
