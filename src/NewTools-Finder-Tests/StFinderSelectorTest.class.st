Class {
	#name : 'StFinderSelectorTest',
	#superclass : 'StFinderTest',
	#category : 'NewTools-Finder-Tests',
	#package : 'NewTools-Finder-Tests'
}

{ #category : 'running' }
StFinderSelectorTest >> setUp [

	super setUp.
	presenterModel currentSearch: StFinderSelectorSearch new
	
]

{ #category : 'tests' }
StFinderSelectorTest >> testSearchForExactCaseInsensitiveStringMissing [

	self openInstance.
	self setExactAndCaseInsensitive.
	self doSearch: 'abcSelector'.

	self assertEmpty: presenter resultTree roots.

]

{ #category : 'tests' }
StFinderSelectorTest >> testSearchForExactCaseInsensitiveStringSucess [

	| results |
	
	self openInstance.
	self setExactAndCaseInsensitive.
	self doSearch: 'abcSelectorSearchForRegexpStartWithoutCase'.

	results := presenter resultTree roots.
	self 
		assert: results size
		equals: 1.
]

{ #category : 'tests' }
StFinderSelectorTest >> testSearchForExactCaseSensitiveStringMissing [

	self openInstance.
	self setExactAndCaseSensitive.
	self doSearch: 'abcselectorSearchForRegexpStartWithoutCase'.	

	self assertEmpty: presenter resultTree roots.

]

{ #category : 'tests' }
StFinderSelectorTest >> testSearchForExactCaseSensitiveStringSucess [

	| results |
	
	self openInstance.
	self setExactAndCaseSensitive.
	self doSearch: 'abcSelectorSearchForRegexpStartWithoutCase'.

	results := presenter resultTree roots.
	self 
		assert: results size
		equals: 1.
]

{ #category : 'tests' }
StFinderSelectorTest >> testSearchForRegexpEndsWithCaseInsensitive [

	| results |
	
	self setRegexAndCaseInsensitive.
	self doSearch: '.*EndsWithAbc$'.
	results := presenter resultTree roots.

	self 
		assertCollection: (results collect: #content)
		hasSameElements: #(#selectorSearchForRegexpWithCaseEndsWithAbc #selectorSearchForRegexpWithoutCaseEndsWithabc).
]

{ #category : 'tests' }
StFinderSelectorTest >> testSearchForRegexpEndsWithCaseSensitive [

	| results |
	
	self setRegexAndCaseSensitive.
	self doSearch: '.*EndsWithAbc$'.
	results := presenter resultTree roots.

	self 
		assertCollection: (results collect: #content)
		hasSameElements: #(#selectorSearchForRegexpWithCaseEndsWithAbc).
]

{ #category : 'tests' }
StFinderSelectorTest >> testSearchForRegexpStartWithCaseInsensitive [

	| results |
	
	self openInstance.
	self setRegexAndCaseInsensitive.
	self doSearch: '^aBC.*'.
	results := presenter resultTree roots.

	self 
		assertCollection: (results collect: #content)
		hasSameElements: #(#aBCSelectorSearchForRegexpStartWithCase #abcSelectorSearchForRegexpStartWithoutCase).
]

{ #category : 'tests' }
StFinderSelectorTest >> testSearchForRegexpStartWithCaseSensitive [

	| results |
	
	self openInstance.
	self setRegexAndCaseSensitive.
	self doSearch: '^aBC.*'.

	results := presenter resultTree roots.
	self 
		assert: results size
		equals: 1.
]

{ #category : 'tests' }
StFinderSelectorTest >> testSubstringSearchNonExistingSelector [

	self openInstance.
	
	presenterModel 
		currentSearch: StFinderSelectorSearch new;	
		search: 'lalala'.
	self assertEmpty: presenter resultTree roots
]
