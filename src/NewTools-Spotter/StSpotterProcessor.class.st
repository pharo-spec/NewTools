Class {
	#name : #StSpotterProcessor,
	#superclass : #Object,
	#instVars : [
		'lastSearchContext',
		'text',
		'steps',
		'process'
	],
	#category : #'NewTools-Spotter'
}

{ #category : #processing }
StSpotterProcessor >> process: aString [

	aString = text ifTrue: [ ^ self ].
	text := aString.
	
	process notNil ifFalse: [ process terminate ].
	process := [ 
		
		process := nil ] 
		forkAt: Processor userBackgroundPriority
		named: 'Spotter processing'.
]
