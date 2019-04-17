Extension { #name : #Collection }

{ #category : #'*NewTools-Inspector' }
Collection >> inspectorItems [
	<inspectorPresentationOrder: 0> 
	
	^ TablePresenter new 
		title: 'Items';
		addColumn: ((IndexTableColumn title: 'Index') width: 40);
		addColumn: (StringTableColumn 
			title: 'Value' 
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each ]);
		items: self asOrderedCollection;
		yourself
]
