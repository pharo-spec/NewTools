Class {
	#name : #StSpotterBaseTest,
	#superclass : #TestCase,
	#instVars : [
		'backendForTest'
	],
	#category : #'NewTools-Spotter-Tests'
}

{ #category : #testing }
StSpotterBaseTest class >> isAbstract [

	^ super isAbstract or: [ self = StSpotterBaseTest ]
]

{ #category : #private }
StSpotterBaseTest >> defer: aBlock [

	World defer: aBlock.
	self waitUntilUIRedrawed
]

{ #category : #private }
StSpotterBaseTest >> setUp [

	super setUp.
	backendForTest := SpMorphicBackendForTest new
]

{ #category : #private }
StSpotterBaseTest >> waitUntilEnded: model [

	[ 50 milliSeconds wait ] 
	doWhileTrue: [ 
		model scheduler workers anySatisfy: [ :each | each isBusy ] ].

]

{ #category : #private }
StSpotterBaseTest >> waitUntilUIRedrawed [

	backendForTest waitUntilUIRedrawed
]
