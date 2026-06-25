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
