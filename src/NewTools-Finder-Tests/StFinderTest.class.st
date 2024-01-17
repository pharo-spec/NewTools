Class {
	#name : 'StFinderTest',
	#superclass : 'TestCase',
	#instVars : [
		'application',
		'presenter',
		'presenterModel'
	],
	#category : 'NewTools-Finder-Tests',
	#package : 'NewTools-Finder-Tests'
}

{ #category : 'running' }
StFinderTest >> classToTest [

	^ StFinderPresenter
]

{ #category : 'tests' }
StFinderTest >> doSearch: searchPattern [

	presenter searchBar searchInput text: searchPattern.
	presenterModel 
		searchString: searchPattern;
		search.
]

{ #category : 'running' }
StFinderTest >> finderPackagesForTests [

	^ #('NewTools-Finder-Tests')
]

{ #category : 'running' }
StFinderTest >> openInstance [

	presenter open.
	presenter window initialPosition: 1 @ 1.
]

{ #category : 'initialization' }
StFinderTest >> setExactAndCaseInsensitive [

	presenter searchOptions exactCheckBox click.
	presenter searchOptions caseCheckBox state: false.
]

{ #category : 'initialization' }
StFinderTest >> setExactAndCaseSensitive [

	presenter searchOptions exactCheckBox click.
	presenter searchOptions caseCheckBox click.
]

{ #category : 'tests' }
StFinderTest >> setRegex [
		
	presenter searchOptions regexpCheckBox click.
]

{ #category : 'tests' }
StFinderTest >> setRegexAndCaseInsensitive [
		
	self setRegex.
	presenter searchOptions caseCheckBox state: false.
]

{ #category : 'tests' }
StFinderTest >> setRegexAndCaseSensitive [
		
	self setRegex.
	presenter searchOptions caseCheckBox click.
]

{ #category : 'running' }
StFinderTest >> setUp [
	super setUp.

	presenter := self classToTest basicNew. 
	presenter setModelBeforeInitialization: StFinderModel new.
	presenter 
		application: StPharoApplication new;
		initialize;
		searchInPackages: self finderPackagesForTests.
	presenterModel := presenter model.
]

{ #category : 'running' }
StFinderTest >> tearDown [

	presenter withWindowDo: [ :window | window close ].
	super tearDown
]
