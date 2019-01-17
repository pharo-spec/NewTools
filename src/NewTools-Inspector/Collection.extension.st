Extension { #name : #Collection }

{ #category : #'*NewTools-Inspector' }
Collection >> inspectorItems [
	<inspectorPresentationOrder: 0> 
	
	^ TablePresenter new 
		title: 'Items';
		hideColumnHeaders;
		addColumn: (StringTableColumn evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each ]);
		items: self asOrderedCollection;
		yourself
]
