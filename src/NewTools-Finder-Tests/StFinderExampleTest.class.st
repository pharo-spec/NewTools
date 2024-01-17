Class {
	#name : 'StFinderExampleTest',
	#superclass : 'StFinderTest',
	#category : 'NewTools-Finder-Tests',
	#package : 'NewTools-Finder-Tests'
}

{ #category : 'running' }
StFinderExampleTest >> setUp [

	super setUp.
	presenterModel currentSearch: StFinderExampleSearch new.
	self openInstance.
	
]

{ #category : 'running' }
StFinderExampleTest >> testConcatenationSearch [

	| results |
	
	self doSearch: '''a''. ''b''. ''ab'''.
	
	results := presenter resultTree roots.
	self assert: results size equals: 2.
]
