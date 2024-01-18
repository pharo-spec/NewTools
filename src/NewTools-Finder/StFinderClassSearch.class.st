"
I implement a search for classes in a given environment.

I am a subclass of ̀FinderSearch̀ and am used by ̀FinderModel̀ to perform searches
for classes.

"
Class {
	#name : 'StFinderClassSearch',
	#superclass : 'StFinderSearch',
	#category : 'NewTools-Finder-Search',
	#package : 'NewTools-Finder',
	#tag : 'Search'
}

{ #category : 'private' }
StFinderClassSearch >> buildResult: aListOfClasses [

	^ aListOfClasses
		  collect: [ :each |
			  | newResult |
			  newResult := StFinderClassResult new content: each.
			  each selectors sort do: [ :selector |
				 newResult addChild: (StFinderSelectorResult new content: selector) ].
			  newResult ]
		  as: OrderedCollection
]

{ #category : 'information' }
StFinderClassSearch >> name [
	"Returns the name of the search."

	^ 'Classes'
]

{ #category : 'searching' }
StFinderClassSearch >> searchByRegexCaseInsensitive: aString in: anEnvironment [
	"Perform a search given aRegex in anEnvironment."

	| regex |
	regex := aString asRegexIgnoringCase.
	^ self 
		buildResult: (self 
			searchClasses: [ :class | regex search: class name ] 
			in: anEnvironment)
]

{ #category : 'searching' }
StFinderClassSearch >> searchByRegexCaseSensitive: aString in: aRBBrowserEnvironment [ 
	"Perform a search given aString representing a regular expression in aRBBrowserEnvironment."

	| regex |
	regex := aString asRegex.
	^ self 
		buildResult: (self 
			searchClasses: [ :class | regex search: class name ] 
			in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderClassSearch >> searchByStringExactInsensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchClasses: [ : class | class name asLowercase = aString asLowercase ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderClassSearch >> searchByStringExactSensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchClasses: [ : class | class name = aString ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderClassSearch >> searchByStringSensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchClasses: [ :class | class name includesSubstring: aString caseSensitive: true ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderClassSearch >> searchBySubstring: aString in: anEnvironment [
	"Perform a search given aString in anEnvironment."

	^ self 
		buildResult: (self searchClasses: [ :class | class name includesSubstring: aString caseSensitive: false ] 
		in: anEnvironment)
]

{ #category : 'searching' }
StFinderClassSearch >> searchClasses: aSelectBlock in: anEnvironment [

	^ OrderedCollection streamContents: [ :stream |
		  anEnvironment classesAndTraitsDo: [ :class |
			  (aSelectBlock value: class) ifTrue: [ stream nextPut: class ] ] ]
]
