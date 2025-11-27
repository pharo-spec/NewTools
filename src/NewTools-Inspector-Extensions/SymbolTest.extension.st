Extension { #name : 'SymbolTest' }

{ #category : '*NewTools-Inspector-Extensions' }
SymbolTest >> testStDisplayString [

	| largeString largeSymbol expectedPrintSymbol |
	largeString := String loremIpsum: 1001.
	largeSymbol := largeString asSymbol.
	expectedPrintSymbol :=  '#''' , (largeString truncateTo: 994) , '[..]'.

	self assert: #test stDisplayString equals: '#test'.
	self assert: #'#test' stDisplayString equals: '#''#test'''.
	self assert: largeSymbol stDisplayString equals: expectedPrintSymbol 
]
