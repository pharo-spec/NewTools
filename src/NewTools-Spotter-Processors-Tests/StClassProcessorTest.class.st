Class {
	#name : 'StClassProcessorTest',
	#superclass : 'StAbstractProcessorTest',
	#category : 'NewTools-Spotter-Processors-Tests',
	#package : 'NewTools-Spotter-Processors-Tests'
}

{ #category : 'tests' }
StClassProcessorTest >> processor [

	^ StClassProcessor new
]

{ #category : 'tests' }
StClassProcessorTest >> testFindStClassProcessorTest [

	self runForText: 'stclassprocessortest'.
	self assertResultsIncludes: StClassProcessorTest
]

{ #category : 'tests' }
StClassProcessorTest >> testFindStClassProcessorTestAfterAddingTest [

	self runForText: 'stclass'.
	self rerunWithText: 'stclassprocess'.
	
	self assertResultsIncludes: StClassProcessorTest 
]

{ #category : 'tests' }
StClassProcessorTest >> testFindStClassProcessorTestWithPartialText [

	self runForText: 'stclasspr'.
	self assertResultsIncludes: StClassProcessorTest
]

{ #category : 'tests' }
StClassProcessorTest >> testPopularStringDoesReturnOnlyTenResults [

	self runForText: 'test'.
	self assertQuantityOfResults: 25.
]

{ #category : 'tests' }
StClassProcessorTest >> testStClassProcessorIsRemovedAfterUpdatingText [

	self runForText: 'gtclass'.
	self rerunWithText: 'gtclassprocesst'.
	
	self denyResultsIncludes: StClassProcessor
]
