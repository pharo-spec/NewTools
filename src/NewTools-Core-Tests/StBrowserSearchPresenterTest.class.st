"
A StBrowserSearchPresenterTest is a test class for testing the behavior of StBrowserSearchPresenter
"
Class {
	#name : 'StBrowserSearchPresenterTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Core-Tests-Calypso',
	#package : 'NewTools-Core-Tests',
	#tag : 'Calypso'
}

{ #category : 'tests' }
StBrowserSearchPresenterTest >> testSearchOfCompileMethods [
	"Regression test. In the past, when we searched for methods, it was not using the display block to search. So it was filtering also based on the class containing the method.
	Now it applies the display block before filtering."

	| presenter methodsToSelect |
	presenter := StBrowserSearchPresenter new
		             items: StBrowserSearchPresenter localMethods;
		             display: [ :aMethod | aMethod selector ].

	methodsToSelect := StBrowserSearchPresenter localMethods select: [ :method | method selector includesSubstring: 'search' caseSensitive: false ].

	presenter searchValue: 'Search'.
	presenter updateList.

	self assertCollection: presenter itemsList items hasSameElements: methodsToSelect
]
