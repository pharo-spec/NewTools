Extension { #name : #String }

{ #category : #'*NewTools-Debugger' }
String >> presentDiffIn: aStFailingAssertionPresenter [
	aStFailingAssertionPresenter initializeStringDiffPresenters
]

{ #category : #'*NewTools-Debugger' }
String >> presentDiffWith: anObject in: aStFailingAssertionPresenter [
	anObject presentDiffIn: aStFailingAssertionPresenter
]
