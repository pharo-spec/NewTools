Class {
	#name : 'StFinderExampleTest',
	#superclass : 'StFinderTest',
	#category : 'NewTools-Finder-Tests-Core',
	#package : 'NewTools-Finder-Tests',
	#tag : 'Core'
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

{ #category : 'running' }
StFinderExampleTest >> testFactorialSearch [

	| results firstResult secondResult |
	
	self doSearch: '3 . 6'.
	
	results := presenter resultTree roots.
	firstResult := results contents first.
	secondResult := results contents second.

	self assert: firstResult content selector equals: #slowFactorial.
	self assert: secondResult content selector equals: #factorial.

]

{ #category : 'running' }
StFinderExampleTest >> testIndexOfSearch [

	| results |
	
	self doSearch: '{2. 4. 5. 1}. 5. 3'.
	
	results := presenter resultTree roots.

	self assert: (results contents anySatisfy: [ : r | r content selector = #indexOf: ])

]

{ #category : 'running' }
StFinderExampleTest >> testNegatedSearch [

	| results singleResult |
	
	self doSearch: '2 . -2'.
	
	results := presenter resultTree roots.
	singleResult := results contents anyOne.
	self assert: singleResult content selector equals: #negated.
]
