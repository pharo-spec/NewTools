Class {
	#name : #StSpotterModel,
	#superclass : #Object,
	#instVars : [
		'candidateAddedAction',
		'searchUpdatedAction',
		'queries',
		'activeQuery'
	],
	#category : #'NewTools-Spotter'
}

{ #category : #private }
StSpotterModel >> activateQuery: aQuery [

	activeQuery := aQuery
]

{ #category : #private }
StSpotterModel >> announceSearchUpdated [

	searchUpdatedAction ifNil: [ ^ self ].
	searchUpdatedAction value
]

{ #category : #processing }
StSpotterModel >> asyncProcess: aString [

	[ self process: aString ] schedule
]

{ #category : #initialization }
StSpotterModel >> initialize [

	super initialize.
	queries := OrderedCollection new
]

{ #category : #processing }
StSpotterModel >> process: aString [
	| query |
	
	query := self queryFor: aString.
	query ifNotNil: [ ^ self activateQuery: query ].

	query := StSpotterQuery on: aString.
	query announcer 
		when: GTSpotterCandidateAdded send: #announceSearchUpdated to: self;
		when: GTSpotterAllCandidatesAdded send: #announceSearchUpdated to: self.
	self activateQuery: query.
	query process
]

{ #category : #private }
StSpotterModel >> queryFor: aString [

	^ queries 
		detect: [ :each | each text = aString ]
		ifNone: [ nil ]
]

{ #category : #accessing }
StSpotterModel >> results [

	^ activeQuery 
		ifNotNil: [ :aQuery | aQuery results ]
		ifNil: [ #() ]
]

{ #category : #processing }
StSpotterModel >> startProcessing [

	self asyncProcess: ''
]

{ #category : #events }
StSpotterModel >> whenSearchUpdatedDo: aBlock [

	searchUpdatedAction := aBlock
]
