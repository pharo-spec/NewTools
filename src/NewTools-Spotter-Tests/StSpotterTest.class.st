Class {
	#name : #StSpotterTest,
	#superclass : #TestCase,
	#instVars : [
		'spotter'
	],
	#category : #'NewTools-Spotter-Tests'
}

{ #category : #running }
StSpotterTest >> setUp [
	
	super setUp.
	spotter := StSpotter new
]

{ #category : #tests }
StSpotterTest >> testSearchingString [

	spotter searchText text: 'Test'.
	self assert: spotter searchingString equals: 'Test'.
	
	spotter searchText text: '#Classes Test'.
	self assert: spotter searchingString equals: 'Test'.
	
	spotter searchText text: '#Classes #Implementors Test'.
	self assert: spotter searchingString equals: 'Test'.
	
	spotter searchText text: '#Classes Test #Implementors'.
	self assert: spotter searchingString equals: 'Test'.
	
	spotter searchText text: '#Classes Test a thing #Implementors'.
	self assert: spotter searchingString equals: 'Test a thing'.
]
