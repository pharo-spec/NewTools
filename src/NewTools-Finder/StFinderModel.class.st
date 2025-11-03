"
Model for the `Finder` tool, responsible for holding the search environment, executing searches and returning search results.

For searching, this class use the interface defined by ̀StFinderSearch̀ and all searches should therefor be subclasses of ̀StFinderSearch̀.

"
Class {
	#name : 'StFinderModel',
	#superclass : 'Model',
	#instVars : [
		'searchString',
		'useRegex',
		'searchEnvironment',
		'currentSearch',
		'results',
		'useExact',
		'useCase',
		'time',
		'availableSearchTargets',
		'useSubstring',
		'application'
	],
	#category : 'NewTools-Finder-Core',
	#package : 'NewTools-Finder',
	#tag : 'Core'
}

{ #category : 'default values' }
StFinderModel class >> defaultSearchTargets [
	"Returns a list of supported searches. Each item in the list is a subclass of `StFinderSearch`."

	"The first element is used as the default search mode."

	^ {
		StFinderSelectorSearch .
		StFinderClassSearch .
		StFinderPackageSearch .
		StFinderSourceSearch .
		StFinderPragmaSearch .
		StFinderExampleSearch 
		}
]

{ #category : 'adding' }
StFinderModel >> addSearch: aFinderSearch [
	"Add aFinderSearch to the availableSearches."

	self availableSearchTargets add: aFinderSearch.
	self searchTypesChanged
]

{ #category : 'accessing' }
StFinderModel >> application [
	^ application
]

{ #category : 'accessing' }
StFinderModel >> application: anApplication [

	application := anApplication.
	self initializeSearchTargets.
]

{ #category : 'information' }
StFinderModel >> availablePackages [
	"Returns for searching available packages by name."

	| globalEnv |
	globalEnv := RBBrowserEnvironment new.
	^ (globalEnv forPackages: globalEnv packages) packages collect: [ :package | package name ] as: OrderedCollection
]

{ #category : 'accessing' }
StFinderModel >> availableSearchTargets [
	"Returns the searches available to the model. The first one is used as the default search mode."

	^ availableSearchTargets
]

{ #category : 'accessing' }
StFinderModel >> availableSearchTargets: aCollection [
	"Set the receiver's targets to aCollection containing <StFinderSearch> instances"

	availableSearchTargets := aCollection
]

{ #category : 'accessing' }
StFinderModel >> availableSearchTargetsFromClasses: aCollection [
	"Set the receiver's targets to aCollection containing classes"

	^ self availableSearchTargets: (self newSearchTargetsWith: aCollection) 
]

{ #category : 'accessing' }
StFinderModel >> currentSearch [
	"Returns the current search used by the model."

	^ currentSearch
]

{ #category : 'accessing' }
StFinderModel >> currentSearch: aSearch [
	"Sets the search used by the model to aSearch. aSearch should be one of the availableSearches."

	currentSearch := aSearch
]

{ #category : 'initialization' }
StFinderModel >> initialize [

	super initialize.
	searchString := ''.
	results := StFinderResult new.
	useRegex := false.
	useExact := false.
	useCase := false.

	self initializeSearchTargets.
	self selectAllPackages
]

{ #category : 'initialization' }
StFinderModel >> initializeSearchTargets [
	"Private - Set the receiver's default search targets"

	self availableSearchTargets: (self newSearchTargetsWith: self class defaultSearchTargets).
	currentSearch := availableSearchTargets first.
]

{ #category : 'initialization' }
StFinderModel >> newSearchTargetsWith: aCollectionOfStFinderSearchClasses [
	"Answer a <Collection> of <StFinderSearch> subinstances matching aCollectionOfStFinderSearch classes"

	^ aCollectionOfStFinderSearchClasses
		collect: [ :searchTargetClass | 
						searchTargetClass new 
							application: self application; 
							yourself ]
		as: OrderedCollection
]

{ #category : 'removing' }
StFinderModel >> removeSearchByName: aString [
	"Removes a search from availableSearches by its name."

	self availableSearchTargets removeAllSuchThat: [ :each | each name = aString ].
	self searchTypesChanged
]

{ #category : 'accessing' }
StFinderModel >> results [

	^ results
]

{ #category : 'searching' }
StFinderModel >> search [
	"Performs a search and stores the results in `self resultsDictionary`."

	searchString isEmpty ifTrue: [ ^ self ].

	[ : job |
		self searchStarted.
		time := Time millisecondsToRun: [ results := self search: searchString ].
		self searchEnded 
	] asJob
			title: 'Searching...';
			run.

]

{ #category : 'accessing' }
StFinderModel >> search: aString [ 
	"Main search callback method. Answer a <Collection> of results"

	^ (currentSearch setSearchStrategyFrom: self searchOptions)
		search: searchString
		in: searchEnvironment.

]

{ #category : 'searching' }
StFinderModel >> searchBy: aString [
	"Perform a search by aString."

	self searchString: aString.
	self search
]

{ #category : 'announcing' }
StFinderModel >> searchEnded [
	"Announce the start of a new search."

	"This method is used internally and called whenever a search has finished."

	self announcer announce:
		(StFinderSearchEnded 
			results: self results 
			time: self time)
]

{ #category : 'accessing' }
StFinderModel >> searchOptions [
	"Answer a <Dictionary> of searching options. This dictionary is set according to the receiver's selected options so their combinatios match a single search selector. At any point only a single entry of this dictionary can be <true>"
	
	^ Dictionary new
		at: #searchByRegexCaseInsensitive:in: put: (useRegex and: [ useCase not ]);
		at: #searchByRegexCaseSensitive:in: put: (useRegex and: [ useCase]);
		at: #searchByStringExactSensitiveCase:in: put: (useExact and: [ useCase and: [ useRegex not ] ]);
		at: #searchByStringExactInsensitiveCase:in: put: (useExact and: [ useCase not and: [ useRegex not ] ]);
		at: #searchByStringSensitiveCase:in: put: (useExact not and: [ useCase and: [ useRegex not ] ]);
		at: #searchBySubstring:in: put: (useExact not and: [ useCase not and: [ useRegex not ] ]);
		yourself

]

{ #category : 'announcing' }
StFinderModel >> searchStarted [
	"Announce the start of a new search."

	"This method is used internally and called whenever a search is started."

	self announcer announce: StFinderSearchStarted new
]

{ #category : 'accessing' }
StFinderModel >> searchString [
	"Return the current search string."

	^ searchString
]

{ #category : 'accessing' }
StFinderModel >> searchString: aString [
	"Set the search string, which is to be used for further searches."

	searchString := aString
]

{ #category : 'announcing' }
StFinderModel >> searchTypesChanged [
	"Announce a modification of availableSearches."

	"This method is used internally and called whenever a availableSearches modified."

	self announcer announce:
		(StFinderSearchTypesChanged newValue: self availableSearchTargets)
]

{ #category : 'selection' }
StFinderModel >> selectAllPackages [
	"Selects all packages for searching."

	| globalEnv |
	
	globalEnv := RBBrowserEnvironment new.
	searchEnvironment := globalEnv forPackages: globalEnv packages
]

{ #category : 'information' }
StFinderModel >> selectedPackages [

	"Returns for searching selected packages by name."

	^ searchEnvironment packageNames asOrderedCollection
]

{ #category : 'selection' }
StFinderModel >> selectedPackagesByName: aCollection [
	"Selects all packages given in aCollection by their names for searching."

	searchEnvironment := RBBrowserEnvironment new forPackageNames: aCollection
]

{ #category : 'accessing' }
StFinderModel >> time [
	^ time
]

{ #category : 'information' }
StFinderModel >> unselectedPackages [
	"Returns for searching unselected packages by name."

	^ self availablePackages \ self selectedPackages
]

{ #category : 'accessing' }
StFinderModel >> useCase [

	^ useCase
]

{ #category : 'accessing' }
StFinderModel >> useCase: aBoolean [

	useCase := aBoolean
]

{ #category : 'accessing' }
StFinderModel >> useExact [

	^ useExact
]

{ #category : 'accessing' }
StFinderModel >> useExact: aBoolean [ 

	useExact := aBoolean
]

{ #category : 'accessing' }
StFinderModel >> useRegex [

	^ useRegex
]

{ #category : 'accessing' }
StFinderModel >> useRegex: aBoolean [

	useRegex := aBoolean
]

{ #category : 'accessing' }
StFinderModel >> useSubstring [

	^ useSubstring
]

{ #category : 'accessing' }
StFinderModel >> useSubstring: aBoolean [

	useSubstring := aBoolean
]

{ #category : 'announcing' }
StFinderModel >> whenSearchEnded: aBlock [
	"Calls aBlock everytime a search has ended and passes the results to it."

	"Culled block [ :results :announcement :announcer | ... ]"

	| block |
	block := [ :announcement :ann |
	         aBlock
		         cull: announcement results
		         cull: announcement time
		         cull: ann ].
	self announcer when: StFinderSearchEnded do: block for: self
]

{ #category : 'announcing' }
StFinderModel >> whenSearchStarted: aBlock [
	"Calls aBlock everytime a search is started."

	"aBlock [ :announcement :announcer | ... ]"

	self announcer
		when: StFinderSearchStarted
		do: aBlock
		for: aBlock receiver
]

{ #category : 'announcing' }
StFinderModel >> whenSearchTypesChanged: aBlock [
	"Calls aBlock everytime a search has been added or removed from availableSearches."

	"Culled block [ :newValue oldValue :announcement :announcer | ... ]"

	| block |
	block := [ :announcement :ann |
	         aBlock
		         cull: announcement newValue
		         cull: announcement oldValue
		         cull: announcement
		         cull: ann ].
	self announcer
		when: StFinderSearchTypesChanged
		do: aBlock
		for: aBlock receiver
]
