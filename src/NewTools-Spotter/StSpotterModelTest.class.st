Class {
	#name : #StSpotterModelTest,
	#superclass : #TestCase,
	#category : #'NewTools-Spotter'
}

{ #category : #tests }
StSpotterModelTest >> testProcess [
	| model |
	
	model := StSpotterModel new.
	model process: 'Object'.
	
]
