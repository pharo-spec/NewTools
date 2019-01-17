Extension { #name : #Collection }

{ #category : #'*NewTools-Inspector' }
Collection >> inspectorItems [
	<inspectorPresentationOrder: 0> 
	
	^ TablePresenter new 
		title: 'Items';
		hideColumnHeaders;
		addColumn: (StringTableColumn new 
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each ];
			yourself);
		items: self asOrderedCollection;
		yourself
]
