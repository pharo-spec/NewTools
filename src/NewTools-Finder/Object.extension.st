Extension { #name : 'Object' }

{ #category : '*NewTools-Finder' }
Object class >> approvedSelectorsForMethodFinder [

	^ #(at: basicAt: basicSize yourself size
	    ->
	    = == ~= hash literalEqual
	   )
]
