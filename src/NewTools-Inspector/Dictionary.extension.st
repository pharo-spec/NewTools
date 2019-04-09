Extension { #name : #Dictionary }

{ #category : #'*NewTools-Inspector' }
Dictionary >> inspectorItems [
	
	^ TablePresenter new 
		title: 'Items';
		addColumn: (StringTableColumn 
			title: 'Key'
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each key ]);
		addColumn: (StringTableColumn 
			title: 'Value' 
			evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each value ]);
		items: self associations;
		yourself
]
