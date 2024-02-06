"
I implement a search for in the source in a given environment.

I am a subclass of ̀StFinderSelectorSearch̀ and am used by ̀StFinderModel̀ to perform searches
for selectors.

"
Class {
	#name : 'StFinderSourceSearch',
	#superclass : 'StFinderSelectorSearch',
	#category : 'NewTools-Finder-Search',
	#package : 'NewTools-Finder',
	#tag : 'Search'
}

{ #category : 'information' }
StFinderSourceSearch >> name [
	"Returns the name of the search."

	^ 'Source'
]

{ #category : 'searching' }
StFinderSourceSearch >> searchByRegexCaseInsensitive: aString in: anEnvironment [
	"Perform a search given aRegex in anEnvironment."

	| regex |
	regex := aString asRegexIgnoringCase.
	^ self buildResult: (self
			   searchMethods: [ :method | regex search: method sourceCode ]
			   in: anEnvironment)
]

{ #category : 'searching' }
StFinderSourceSearch >> searchByRegexCaseSensitive: aString in: aRBBrowserEnvironment [ 
	"Perform a search given aString representing a regular expression in aRBBrowserEnvironment."

	| regex |
	regex := aString asRegex.
	^ self 
		buildResult: (self 
			searchMethods: [ :method | regex search: method sourceCode ] 
			in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderSourceSearch >> searchByStringExactInsensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchMethods: [ :method | method sourceCode asLowercase = aString asLowercase ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderSourceSearch >> searchByStringExactSensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchMethods: [ :method | method sourceCode = aString ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderSourceSearch >> searchByStringSensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchMethods: [ :method | method sourceCode includesSubstring: aString caseSensitive: true ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderSourceSearch >> searchBySubstring: aString in: anEnvironment [
	"Perform a search given aString in anEnvironment."

	^ self buildResult: (self
	   searchMethods: [ :method | method sourceCode includesSubstring: aString caseSensitive: false ]
	   in: anEnvironment)
]
