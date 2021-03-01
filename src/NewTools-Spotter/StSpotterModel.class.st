Class {
	#name : #StSpotterModel,
	#superclass : #Object,
	#instVars : [
		'candidateAddedAction',
		'searchUpdatedAction',
		'queries',
		'activeQuery',
		'processors',
		'amountChangedAction'
	],
	#category : #'NewTools-Spotter-Model'
}

{ #category : #private }
StSpotterModel >> activateQuery: aQuery [

	activeQuery ifNotNil: [ self disconnectQuery: aQuery ].
	activeQuery := aQuery.
	self connectQuery: aQuery
]

{ #category : #private }
StSpotterModel >> announceAllCandidatesAdded: ann [

	searchUpdatedAction ifNil: [ ^ self ].
	
	ann candidateLinks do: [ :each |
		searchUpdatedAction value: each ]
]

{ #category : #private }
StSpotterModel >> announceAmountChanged: ann [

	amountChangedAction ifNil: [ ^ self ].
	amountChangedAction 
		value: ann category 
		value: ann amount
]

{ #category : #private }
StSpotterModel >> announceCandidateAdded: ann [

	searchUpdatedAction ifNil: [ ^ self ].
	searchUpdatedAction value: ann candidateLink
]

{ #category : #processing }
StSpotterModel >> asyncProcess: aString [

	[ 
		Processor yield.
		self process: aString. 
	] schedule
]

{ #category : #private }
StSpotterModel >> connectQuery: aQuery [

	aQuery announcer
		when: StSpotterCandidateAdded send: #announceCandidateAdded: to: self;
		when: StSpotterAllCandidatesAdded send: #announceAllCandidatesAdded: to: self;
		when: StSpotterCandidatesAmountChanged send: #announceAmountChanged: to: self.	
]

{ #category : #private }
StSpotterModel >> defaultProcessors [

	^ (StSpotterProcessor allEnabledSubclasses 
		collect: [ :each | each new ])
		sort: #order ascending
]

{ #category : #private }
StSpotterModel >> disconnectQuery: aQuery [

	aQuery announcer unsubscribe: self
]

{ #category : #initialization }
StSpotterModel >> initialize [

	super initialize.
	queries := OrderedCollection new
]

{ #category : #accessing }
StSpotterModel >> links [

	^ activeQuery 
		ifNotNil: [ :aQuery | aQuery links ]
		ifNil: [ #() ]
]

{ #category : #processing }
StSpotterModel >> process: aString [
	| query |
	
	query := self queryFor: aString.
	query ifNotNil: [ ^ self activateQuery: query ].

	query := StSpotterQuery on: aString.
	query processors: self processors.
	self activateQuery: query.
	query process
]

{ #category : #accessing }
StSpotterModel >> processors [

	^ processors ifNil: [ processors := self defaultProcessors ]
]

{ #category : #private }
StSpotterModel >> queryFor: aString [

	^ queries 
		detect: [ :each | each searchText = aString ]
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

	"First query: empty (to bring windows, menu, etc.)"
	self asyncProcess: ''
]

{ #category : #events }
StSpotterModel >> whenAmountChangedDo: aBlock [

	amountChangedAction := aBlock
]

{ #category : #events }
StSpotterModel >> whenSearchUpdatedDo: aBlock [

	searchUpdatedAction := aBlock
]
