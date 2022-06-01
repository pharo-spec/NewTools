Extension { #name : #Array2D }

{ #category : #'*NewTools-Inspector-Extensions' }
Array2D >> inspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Matrix'>
	
	| specTable |
	specTable := SpTablePresenter new.
	specTable addColumn: (SpIndexTableColumn new
		title: '#';
		width: 30;
		yourself).

	1 to: numberOfColumns do: [ :index | 
		specTable addColumn: (SpStringTableColumn new
			title: index asString;
			evaluated: [ :each | each at: index ];
			beNotExpandable) ].
	
	specTable items: ((1 to: numberOfRows) collect: [ :index | self atRow: index ]).
	^ specTable 
]
