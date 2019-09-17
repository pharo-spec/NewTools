Extension { #name : #Dictionary }

{ #category : #'*NewTools-Inspector-Extensions' }
Dictionary >> inspectorItems [
	
	^ SpTablePresenter new 
		title: 'Items';
		addColumn: (SpStringTableColumn 
			title: 'Key'
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each key ]);
		addColumn: (SpStringTableColumn 
			title: 'Value' 
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each value ]);
		items: self associations;
		yourself
]
