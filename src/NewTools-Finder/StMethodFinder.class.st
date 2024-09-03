"
Extends `MethodFinder` to add support for search examples with:

- Timeout evaluation
- Logging

"
Class {
	#name : 'StMethodFinder',
	#superclass : 'MethodFinder',
	#category : 'NewTools-Finder-Search',
	#package : 'NewTools-Finder',
	#tag : 'Search'
}

{ #category : 'public access' }
StMethodFinder >> findMethodsByExampleInput: inputCollection andExpectedResult: expectedResult timeout: anInteger [
	"Search for methods which giving each elements of input returns the corresponding elements of outputs."
	
	| evaluationSelector |

	evaluationSelector := anInteger = 0
		ifTrue: [ #resultIn: ]
		ifFalse: [ #resultIn:timeout: ].
	^ (self possibleSolutionsForInput: inputCollection) asSet select: [ :send |
		  send 
				perform: evaluationSelector 
				withArguments: { 
					(expectedResult evaluateWithTimeOut: anInteger) .
					anInteger } ]
]

{ #category : 'public access' }
StMethodFinder >> methodFinderSendClass [

	^ StMethodFinderSend
]
