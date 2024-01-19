"
I implement a search for classes in a given environment.

I am a subclass of ̀FinderSearch̀ and am used by ̀FinderModel̀ to perform searches
for classes.

"
Class {
	#name : 'StFinderPackageSearch',
	#superclass : 'StFinderSearch',
	#category : 'NewTools-Finder-Search',
	#package : 'NewTools-Finder',
	#tag : 'Search'
}

{ #category : 'private' }
StFinderPackageSearch >> buildResult: aListOfPackages [

	^ aListOfPackages
		  collect: [ :each |
			  | newResult |
			  newResult := StFinderPackageResult new content: each.
			  each definedClasses do: [ : class |
				 newResult addChild: (StFinderClassResult new content: class) ].
			  newResult  ]
		  as: OrderedCollection
]

{ #category : 'information' }
StFinderPackageSearch >> name [
	"Returns the name of the search."

	^ 'Packages'
]

{ #category : 'searching' }
StFinderPackageSearch >> searchByRegexCaseInsensitive: aString in: anEnvironment [
	"Perform a search given aRegex in anEnvironment."

	| regex |
	regex := aString asRegexIgnoringCase.
	^ self 
		buildResult: (self 
			searchPackages: [ :class | regex search: class name ] 
			in: anEnvironment)
]

{ #category : 'searching' }
StFinderPackageSearch >> searchByRegexCaseSensitive: aString in: aRBBrowserEnvironment [ 
	"Perform a search given aString representing a regular expression in aRBBrowserEnvironment."

	| regex |
	regex := aString asRegex.
	^ self 
		buildResult: (self 
			searchPackages: [ :class | regex search: class name ] 
			in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderPackageSearch >> searchByStringExactInsensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchPackages: [ : class | class name asLowercase = aString asLowercase ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderPackageSearch >> searchByStringExactSensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchPackages: [ : class | class name = aString ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderPackageSearch >> searchByStringSensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchPackages: [ :package | package name includesSubstring: aString caseSensitive: true ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderPackageSearch >> searchBySubstring: aString in: anEnvironment [
	"Perform a search given aString in anEnvironment."

	^ self buildResult: 
		(self 
			searchPackages: [ :class | class name includesSubstring: aString caseSensitive: false ] 
			in: anEnvironment)
]

{ #category : 'private' }
StFinderPackageSearch >> searchPackages: aSelectBlock in: anEnvironment [

	^ OrderedCollection streamContents: [ :stream |
		  anEnvironment packages do: [ : package |
			  (aSelectBlock value: package) ifTrue: [ stream nextPut: package ] ] ]
]
