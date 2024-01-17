Class {
	#name : 'StFinderPackageTest',
	#superclass : 'StFinderTest',
	#category : 'NewTools-Finder-Tests',
	#package : 'NewTools-Finder-Tests'
}

{ #category : 'running' }
StFinderPackageTest >> setUp [

	super setUp.
	presenterModel currentSearch: StFinderPackageSearch new
	
]

{ #category : 'tests' }
StFinderPackageTest >> testSearchForExactCaseInsensitiveStringMissing [

	self openInstance.
	self setExactAndCaseInsensitive.
	self doSearch: 'newtools-finder'.

	self assertEmpty: presenter resultTree roots.

]

{ #category : 'tests' }
StFinderPackageTest >> testSearchForExactCaseInsensitiveStringSucess [

	| results |
	
	self openInstance.
	self setExactAndCaseInsensitive.
	self doSearch: 'newtools-finder-tests'.

	results := presenter resultTree roots.
	self 
		assertCollection: (results collect: [ : r | r content name ])
		hasSameElements: #('NewTools-Finder-Tests').
]

{ #category : 'tests' }
StFinderPackageTest >> testSearchForExactCaseSensitiveStringMissing [

	self openInstance.
	self setExactAndCaseSensitive.
	self doSearch: 'NewTools-Finder'.	

	self assertEmpty: presenter resultTree roots.

]

{ #category : 'tests' }
StFinderPackageTest >> testSearchForExactCaseSensitiveStringSucess [

	| results |
	
	self openInstance.
	self setExactAndCaseSensitive.
	self doSearch: 'NewTools-Finder-Tests'.

	results := presenter resultTree roots.
	self 
		assert: results size
		equals: 1.
]

{ #category : 'tests' }
StFinderPackageTest >> testSearchForRegexpStartWithCaseInsensitive [

	| results |
	
	self openInstance.
	self setRegexAndCaseInsensitive.
	self doSearch: '^newTools-finder'.	
	results := presenter resultTree roots.

	self 
		assertCollection: (results collect: [ : r | r content name ])
		hasSameElements: #(#'NewTools-Finder-Tests').
]

{ #category : 'tests' }
StFinderPackageTest >> testSearchForRegexpStartWithCaseSensitive [

	| results |
	
	self openInstance.
	self setRegexAndCaseSensitive.
	self doSearch: '^NewTools-Finder'.	
	results := presenter resultTree roots.
	self 
		assert: results size
		equals: 1.
]

{ #category : 'tests' }
StFinderPackageTest >> testSubstringSearchNonExistingPackage [

	self openInstance.
	
	self doSearch: 'NonExistingPackage'.
	self assertEmpty: presenter resultTree roots
]
