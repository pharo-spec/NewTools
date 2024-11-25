"
I am an abstract base class for searches in the `Finder` Tool.

It provides a common interface for performing searches and results are expected to be returned in form of a `StFinderResult` composite object.

# Subclass Responsibilities

The following methods must be provided by subclasses of me.

- **_name_** returns the name of the search
- **_searchByString:in:_** performs a search for given search string.
- **_searchByRegex:in:_** performs a search for a given `RxMatcher` object.


"
Class {
	#name : 'StFinderSearch',
	#superclass : 'Object',
	#instVars : [
		'searchSelector',
		'application'
	],
	#category : 'NewTools-Finder-Search',
	#package : 'NewTools-Finder',
	#tag : 'Search'
}

{ #category : 'accessing' }
StFinderSearch >> application [

	^ application 
		ifNil: [ StPharoApplication current ]
]

{ #category : 'accessing' }
StFinderSearch >> application: anApplication [ 
	application := anApplication
]

{ #category : 'private' }
StFinderSearch >> buildResult: aListOfClasses [ 
	^ self subclassResponsibility
]

{ #category : 'testing' }
StFinderSearch >> isFinderExampleSearch [

	^ false
]

{ #category : 'information' }
StFinderSearch >> name [

	"Returns the name of the search."

	self subclassResponsibility
]

{ #category : 'accessing' }
StFinderSearch >> previewPresenter [
	"Answer the presenter <Class> responsible to display the preview in the Finder according to the receiver's contents"
	
	^ SpCodePresenter 

]

{ #category : 'accessing' }
StFinderSearch >> previewText [

	^ String empty
]

{ #category : 'accessing' }
StFinderSearch >> search: aString in: aRBBrowserEnvironment [ 
	"Answer a <Collection> of results"

	^ self 
		perform: searchSelector 
		withArguments: {
			aString .
			aRBBrowserEnvironment }
]

{ #category : 'searching' }
StFinderSearch >> searchByRegexCaseInsensitive: aRegex in: anEnvironment [
	"Perform a search given aRegex in anEnvironment."

	self subclassResponsibility
]

{ #category : 'searching' }
StFinderSearch >> searchBySubstring: aString in: anEnvironment [
	"Perform a search given aString in anEnvironment."

	self subclassResponsibility
]

{ #category : 'initialization' }
StFinderSearch >> setSearchStrategyFrom: aDictionary [
	"Set the receiver's search strategy according to aCollection of options"
	
	searchSelector := aDictionary keyAtValue: true.
]

{ #category : 'information' }
StFinderSearch >> updateDefaultPreview: aSpCodePresenter [ 

	aSpCodePresenter text: 'Search for ' , self name
]

{ #category : 'accessing' }
StFinderSearch >> validSearchOptions [
	"Answer a <Collection> of valid search options for the receiver"
	
	^ #(#activateAll)
]
