Extension { #name : #Integer }

{ #category : #'*NewTools-Inspector-Extensions' }
Integer >> inspectIntegerIn: aBuilder [
	<inspectorPresentationOrder: 30 title: 'Integer'> 
	| keysColumn valuesColumn items |
	items := { 'decimal' -> self printString.
					'hex' -> self printStringHex.
					'octal' -> (self printStringBase: 8).
					'binary' -> (self printStringBase: 2)} asOrderedCollection.
					
	keysColumn := SpStringTableColumn title: #key evaluated: [ :anAssociation | anAssociation key ].
	valuesColumn := SpStringTableColumn title: #value evaluated: [ :anAssociation | anAssociation value ].
	
	^ aBuilder newTable
		addColumn: keysColumn;
		addColumn: valuesColumn;
		items: items;
		yourself
]
