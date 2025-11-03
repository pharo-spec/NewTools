"
I implement a search for selectors in a given environment.

I am a subclass of ̀FinderSearch̀ and am used by ̀FinderModel̀ to perform searches
for selectors.

"
Class {
	#name : 'StFinderSelectorSearch',
	#superclass : 'StFinderSearch',
	#category : 'NewTools-Finder-Search',
	#package : 'NewTools-Finder',
	#tag : 'Search'
}

{ #category : 'private' }
StFinderSelectorSearch >> buildResult: aListOfMethods [

	| results |
	results := OrderedCollection new.

	aListOfMethods do: [ :method |
		| foundResult |

		foundResult := StFinderResult newFor: method.
		foundResult application: application.
		
		results
			detect: [ :elem | elem content = method selector ]
			ifFound: [ :elem | elem addChild: foundResult ]
			ifNone: [
				| newResult |
				newResult := StFinderSelectorResult new
					             content: method selector;
									 application: application;
					             addChild: foundResult;
					             yourself.
				results add: newResult ] ].

	^ results
]

{ #category : 'information' }
StFinderSelectorSearch >> name [
	"Returns the name of the search."

	^ 'Selectors'
]

{ #category : 'searching' }
StFinderSelectorSearch >> searchByRegexCaseInsensitive: aString in: anEnvironment [
	"Perform a search given aRegex in anEnvironment."

	| regex |
	regex := aString asRegexIgnoringCase.
	^ self buildResult: 
		(self 
			searchMethods: [ :method | regex search: method selector ] 
			in: anEnvironment)
]

{ #category : 'searching' }
StFinderSelectorSearch >> searchByRegexCaseSensitive: aString in: aRBBrowserEnvironment [ 
	"Perform a search given aString representing a regular expression in aRBBrowserEnvironment."

	| regex |
	regex := aString asRegex.
	^ self 
		buildResult: (self 
			searchMethods: [ :method | regex search: method selector ] 
			in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderSelectorSearch >> searchByStringExactInsensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchMethods: [ :method | method selector asLowercase = aString asLowercase ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderSelectorSearch >> searchByStringExactSensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchMethods: [ :method | method selector = aString ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderSelectorSearch >> searchByStringSensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchMethods: [ :method | method selector includesSubstring: aString caseSensitive: true ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderSelectorSearch >> searchBySubstring: aString in: anEnvironment [
	"Perform a search given aString in anEnvironment."

	^ self buildResult: (self 
		searchMethods: [ :method | method selector includesSubstring: aString caseSensitive: false ] 
		in: anEnvironment)
]

{ #category : 'private' }
StFinderSelectorSearch >> searchMethods: aSelectBlock in: anEnvironment [

	^ OrderedCollection streamContents: [ :stream | "This should just be
		 anEnvironment methodsDo: [ :method | (aSelectBlock value: method) ifTrue: [ stream nextPut: method ] ]
		
		But currently the code is way too slow if we do that.
		"
		  anEnvironment classesDo: [ :class | class methodsDo: [ :method | (aSelectBlock value: method) ifTrue: [ stream nextPut: method ] ] ] ]
]
