Extension { #name : 'Symbol' }

{ #category : '*NewTools-Finder' }
Symbol class >> forbiddenSelectorsForMethodFinder [

	^ super forbiddenSelectorsForMethodFinder , #( string: #privateAt:put: )
]
