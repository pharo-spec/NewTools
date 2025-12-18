Class {
	#name : 'StPharoToploApplication',
	#superclass : 'StPharoApplication',
	#category : 'NewTools-Toplo',
	#package : 'NewTools-Toplo'
}

{ #category : 'as yet unclassified' }
StPharoToploApplication >> openAsWorld: aStWorldPresenter [

	| window s |
	window := aStWorldPresenter asWindow.
	window layout adapterClass: SpToploWindowAdapter.
	window open.

	s := Semaphore new.
	window adapter defer: [ s signal ].

	s waitTimeoutMilliseconds: 1 second asMilliSeconds.
	
	^ window
]

{ #category : 'serializing' }
StPharoToploApplication >> useDuring: aBlock [

	^ self class use: self during: aBlock
]

{ #category : 'as yet unclassified' }
StPharoToploApplication >> useInnerWindowAdapter [

	backend useInnerWindowAdapter
]
