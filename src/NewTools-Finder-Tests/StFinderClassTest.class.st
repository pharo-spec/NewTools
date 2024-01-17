Class {
	#name : 'StFinderClassTest',
	#superclass : 'StFinderTest',
	#category : 'NewTools-Finder-Tests',
	#package : 'NewTools-Finder-Tests'
}

{ #category : 'running' }
StFinderClassTest >> setUp [

	super setUp.
	presenterModel currentSearch: StFinderClassSearch new
	
]

{ #category : 'tests' }
StFinderClassTest >> testSearchForExactCaseInsensitiveStringMissing [

	self openInstance.
	self setExactAndCaseInsensitive.
	self doSearch: 'stfindermock'.

	self assertEmpty: presenter resultTree roots.

]

{ #category : 'tests' }
StFinderClassTest >> testSearchForExactCaseInsensitiveStringSucess [

	| results |
	
	self openInstance.
	self setExactAndCaseInsensitive.
	self doSearch: 'stfindermocka'.

	results := presenter resultTree roots.
	self 
		assertCollection: (results collect: [ : r | r content name ])
		hasSameElements: #(#StFinderMockA #StFinderMocka).
]

{ #category : 'tests' }
StFinderClassTest >> testSearchForExactCaseSensitiveStringMissing [

	self openInstance.
	self setExactAndCaseSensitive.
	self doSearch: 'StFinderMock'.

	self assertEmpty: presenter resultTree roots.

]

{ #category : 'tests' }
StFinderClassTest >> testSearchForExactCaseSensitiveStringSucess [

	| results |
	
	self openInstance.
	self setExactAndCaseSensitive.
	self doSearch: 'StFinderMockA'.

	results := presenter resultTree roots.
	self 
		assert: results size
		equals: 1.
]

{ #category : 'tests' }
StFinderClassTest >> testSearchForRegexpStartWithCaseInsensitive [

	| results |
	
	self openInstance.
	self setRegexAndCaseInsensitive.
	self doSearch: '^StFinderMockA'.	
	results := presenter resultTree roots.

	self 
		assertCollection: (results collect: [ : r | r content name ])
		hasSameElements: #(#StFinderMockA #StFinderMocka).
]

{ #category : 'tests' }
StFinderClassTest >> testSearchForRegexpStartWithCaseSensitive [

	| results |
	
	self openInstance.
	self setRegexAndCaseSensitive.
	self doSearch: '^StFinderMockA'.
	results := presenter resultTree roots.
	self 
		assert: results size
		equals: 1.
]

{ #category : 'tests' }
StFinderClassTest >> testSubstringSearchNonExistingClass [

	self openInstance.
	self doSearch: 'NonExistingClass'.

	self assertEmpty: presenter resultTree roots
]
