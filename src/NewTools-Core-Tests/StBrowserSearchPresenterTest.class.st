"
A StBrowserSearchPresenterTest is a test class for testing the behavior of StBrowserSearchPresenter
"
Class {
	#name : 'StBrowserSearchPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'savedSearches'
	],
	#category : 'NewTools-Core-Tests-Calypso',
	#package : 'NewTools-Core-Tests',
	#tag : 'Calypso'
}

{ #category : 'helpers' }
StBrowserSearchPresenterTest >> newPresenter [

	^ StBrowserSearchPresenter new
		  items: (StBrowserSearchPresenter withAllSuperclasses sorted: #name ascending);
		  yourself
]

{ #category : 'helpers' }
StBrowserSearchPresenterTest >> search: aString thenAccept: aBoolean [
	"Open a search dialog remembering its search as #class, type aString, and accept it or cancel it"

	[
	SpWindowSimulateOpenModal
		value: [ :dialog |
			dialog presenter searchValue: aString.
			aBoolean ifTrue: [ dialog beOk ].
			dialog close ]
		during: [
			StBrowserSearchPresenter new searchConfiguring: [ :presenter |
				presenter
					items: (StBrowserSearchPresenter withAllSuperclasses sorted: #name ascending);
					rememberSearchAs: #class ] ] ]
		on: CmCommandAborted
		do: [ :exception | exception return: nil ]
]

{ #category : 'running' }
StBrowserSearchPresenterTest >> setUp [

	super setUp.
	savedSearches := StBrowserSearchPresenter lastSearches.
	StBrowserSearchPresenter lastSearches: Dictionary new
]

{ #category : 'running' }
StBrowserSearchPresenterTest >> tearDown [

	StBrowserSearchPresenter lastSearches: savedSearches.
	super tearDown
]

{ #category : 'tests - remembered search' }
StBrowserSearchPresenterTest >> testAcceptingRemembersTheSearch [

	self search: 'Presenter' thenAccept: true.
	self assert: (StBrowserSearchPresenter lastSearchAs: #class) equals: 'Presenter'
]

{ #category : 'tests - remembered search' }
StBrowserSearchPresenterTest >> testCancellingDoesNotRememberTheSearch [

	self search: 'Presenter' thenAccept: false.
	self assert: (StBrowserSearchPresenter lastSearchAs: #class) isEmpty
]

{ #category : 'tests - remembered search' }
StBrowserSearchPresenterTest >> testRememberedSearchFillsTheSearchField [

	| presenter |
	StBrowserSearchPresenter rememberSearch: 'Presenter' as: #class.
	presenter := self newPresenter rememberSearchAs: #class.
	self assert: presenter searchValue equals: 'Presenter'
]

{ #category : 'tests - remembered search' }
StBrowserSearchPresenterTest >> testRememberedSearchFiltersTheList [

	| presenter |
	StBrowserSearchPresenter rememberSearch: 'Presenter' as: #class.
	presenter := self newPresenter rememberSearchAs: #class.
	self
		assert: (presenter itemsList items collect: [ :each | each name ] as: Array)
		equals: #( #SpAbstractPresenter #SpPresenter #StBrowserSearchPresenter #StPresenter )
]

{ #category : 'tests' }
StBrowserSearchPresenterTest >> testSearchOfCompileMethods [
	"Regression test. In the past, when we searched for methods, it was not using the display block to search. So it was filtering also based on the class containing the method.
	Now it applies the display block before filtering."

	| presenter methodsToSelect pattern |
	pattern := 'Search'.
	self
		assert: (StBrowserSearchPresenter name includesSubstring: pattern)
		description: 'This test ensure we search only the selector of a compiled method and not the class name. So the class name needs to contain the pattern.'.
	presenter := StBrowserSearchPresenter new
		             items: StBrowserSearchPresenter localMethods;
		             display: [ :aMethod | aMethod selector ].

	methodsToSelect := StBrowserSearchPresenter localMethods select: [ :method | method selector includesSubstring: pattern caseSensitive: false ].

	presenter searchValue: pattern.
	presenter updateList.

	self assertCollection: presenter itemsList items hasSameElements: methodsToSelect
]

{ #category : 'tests - remembered search' }
StBrowserSearchPresenterTest >> testSearchesAreRememberedPerKey [

	| presenter |
	StBrowserSearchPresenter rememberSearch: 'Presenter' as: #package.
	presenter := self newPresenter rememberSearchAs: #class.
	self assert: presenter searchValue isEmpty
]

{ #category : 'tests - remembered search' }
StBrowserSearchPresenterTest >> testTheNextDialogStartsWithTheAcceptedSearch [

	self search: 'Presenter' thenAccept: true.
	self assert: (self newPresenter rememberSearchAs: #class) searchValue equals: 'Presenter'
]

{ #category : 'tests - remembered search' }
StBrowserSearchPresenterTest >> testWithoutRememberingTheSearchFieldStartsEmpty [

	StBrowserSearchPresenter rememberSearch: 'Presenter' as: #class.
	self assert: self newPresenter searchValue isEmpty
]
