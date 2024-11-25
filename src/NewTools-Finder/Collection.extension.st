Extension { #name : 'Collection' }

{ #category : '*NewTools-Finder' }
Collection class >> approvedSelectorsForMethodFinder [
	^ self selectors
]

{ #category : '*NewTools-Finder' }
Collection class >> forbiddenSelectorsForMethodFinder [

	^ #( #combinations )
]
