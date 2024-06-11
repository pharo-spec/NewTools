Class {
	#name : 'StSpotterBaseTest',
	#superclass : 'TestCase',
	#instVars : [
		'backendForTest'
	],
	#category : 'NewTools-Spotter-Tests',
	#package : 'NewTools-Spotter-Tests'
}

{ #category : 'testing' }
StSpotterBaseTest class >> isAbstract [

	^ super isAbstract or: [ self = StSpotterBaseTest ]
]

{ #category : 'private' }
StSpotterBaseTest >> defer: aBlock [

	World defer: aBlock.
	self waitUntilUIRedrawed
]

{ #category : 'running' }
StSpotterBaseTest >> setUp [

	super setUp.
	backendForTest := SpMorphicBackendForTest new
]

{ #category : 'private' }
StSpotterBaseTest >> waitUntilEnded: model [

	[ (StSpotterModel delayBeforeQuery + 50 milliSeconds) wait ] 
	doWhileTrue: [ 
		model scheduler workers anySatisfy: [ :each | each isBusy ] ].

]

{ #category : 'private' }
StSpotterBaseTest >> waitUntilUIRedrawed [

	backendForTest waitUntilUIRedrawed
]
