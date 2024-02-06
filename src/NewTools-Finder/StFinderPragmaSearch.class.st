"
I implement a search for pragmas in a given environment.

I am a subclass of ̀FinderSearch̀ and am used by ̀FinderModel̀ to perform searches
for selectors.

"
Class {
	#name : 'StFinderPragmaSearch',
	#superclass : 'StFinderSearch',
	#category : 'NewTools-Finder-Search',
	#package : 'NewTools-Finder',
	#tag : 'Search'
}

{ #category : 'private' }
StFinderPragmaSearch >> buildResult: aDictionary [
	"PragmaResult
		|
		\-> n SelectorResults
				|
				\-> 1 ClassResults."

	| results isNewResult |
	results := OrderedCollection new.
	isNewResult := true.

	aDictionary keysAndValuesDo: [ :pragma :methods |
		| pragmaResult |
		"Sadly Pragmas with the same selector are not unique keys in a Dictionary."
		pragmaResult := results
			                detect: [ :result |
			                result content selector = pragma ]
			                ifFound: [ :result |
				                isNewResult := false.
				                result ]
			                ifNone: [ StFinderPragmaResult new content: pragma ].

		methods do: [ :method |
			| classResult |
			classResult := StFinderClassResult new content: method methodClass.
			pragmaResult children
				detect: [ :elem | elem content = method selector ]
				ifFound: [ :elem | elem addChild: classResult ]
				ifNone: [
					| selectorResult |
					selectorResult := StFinderSelectorResult new
						                  content: method;
						                  addChild: classResult;
						                  yourself.
					pragmaResult addChild: selectorResult ] ].

		isNewResult ifTrue: [ results add: pragmaResult ] ].

	^ results
]

{ #category : 'searching' }
StFinderPragmaSearch >> excludePragmaDelimiters: aString [

	^ aString trimBoth: [ :c | { $< .$> } includes: c ]
]

{ #category : 'information' }
StFinderPragmaSearch >> name [
	"Returns the name of the search."

	^ 'Pragmas'
]

{ #category : 'searching' }
StFinderPragmaSearch >> searchByRegexCaseInsensitive: aString in: anEnvironment [
	"Perform a search given aRegex in anEnvironment."

	| regex |
	regex := aString asRegexIgnoringCase.
	^ self buildResult: (self
			   searchPragmas: [ :pragma | regex search: pragma selector ]
			   in: anEnvironment)
]

{ #category : 'searching' }
StFinderPragmaSearch >> searchByStringExactInsensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchPragmas: [ : pragma | pragma selector asLowercase = (self excludePragmaDelimiters: aString asLowercase) ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderPragmaSearch >> searchByStringExactSensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchPragmas: [ : pragma | pragma selector = (self excludePragmaDelimiters: aString) ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderPragmaSearch >> searchByStringSensitiveCase: aString in: aRBBrowserEnvironment [ 

	^ self buildResult: (self 
		searchPragmas: [ : pragma | pragma selector includesSubstring: (self excludePragmaDelimiters: aString) caseSensitive: true ] 
		in: aRBBrowserEnvironment)
]

{ #category : 'searching' }
StFinderPragmaSearch >> searchBySubstring: aString in: anEnvironment [
	"Perform a search given aString in anEnvironment."

	^ self buildResult: (self
			   searchPragmas: [ :pragma |
				   pragma selector 
					   includesSubstring: (self excludePragmaDelimiters: aString)
					   caseSensitive: false ]
			   in: anEnvironment)
]

{ #category : 'private' }
StFinderPragmaSearch >> searchPragmas: aSelectBlock in: anEnvironment [

	| findings |
	findings := Dictionary new.

	anEnvironment classesAndTraitsDo: [ :class |
		class pragmasDo: [ :pragma |
			(aSelectBlock value: pragma) ifTrue: [
				(findings at: pragma selector ifAbsentPut: OrderedCollection new)
					add: pragma method ] ].
		"Include Metaclasses too, since a lot of pragmas are only found there."
		class class pragmasDo: [ :pragma |
			(aSelectBlock value: pragma) ifTrue: [
				(findings at: pragma ifAbsentPut: OrderedCollection new)
					add: pragma method ] ] ].

	^ findings
]
