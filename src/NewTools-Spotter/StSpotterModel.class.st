Class {
	#name : #StSpotterModel,
	#superclass : #Object,
	#instVars : [
		'candidateAddedAction',
		'searchUpdatedAction',
		'queries',
		'activeQuery',
		'processors',
		'amountChangedAction',
		'workerSemaphore',
		'worker',
		'requestedText',
		'mutex',
		'queryStartedAction',
		'queryEndedAction'
	],
	#category : #'NewTools-Spotter-Model'
}

{ #category : #private }
StSpotterModel >> activateQuery: aQuery [

	activeQuery ifNotNil: [ self disconnectQuery: aQuery ].
	activeQuery := aQuery.
	self connectQuery: aQuery.
	self refreshQueryStatus: aQuery.
]

{ #category : #'private announcing' }
StSpotterModel >> announceAllCandidatesAdded: ann [

	searchUpdatedAction ifNil: [ ^ self ].
	ann candidateLinks 
		do: [ :each | searchUpdatedAction value: each ]
]

{ #category : #'private announcing' }
StSpotterModel >> announceAmountChanged: ann [

	amountChangedAction ifNil: [ ^ self ].
	amountChangedAction 
		value: ann category 
		value: ann amount
]

{ #category : #'private announcing' }
StSpotterModel >> announceCandidateAdded: ann [

	searchUpdatedAction ifNil: [ ^ self ].
	searchUpdatedAction value: ann candidateLink
]

{ #category : #'private announcing' }
StSpotterModel >> announceQueryEnded: ann [

	queryEndedAction ifNil: [ ^ self ].
	queryEndedAction value
]

{ #category : #'private announcing' }
StSpotterModel >> announceQueryStarted: ann [

	queryStartedAction ifNil: [ ^ self ].
	queryStartedAction value
]

{ #category : #processing }
StSpotterModel >> asyncProcess: aString [

	[
		mutex critical: [ 
			requestedText := aString.
			self triggerWorker ] ]
	schedule
]

{ #category : #private }
StSpotterModel >> connectQuery: aQuery [

	aQuery announcer
		when: StSpotterCandidateAdded send: #announceCandidateAdded: to: self;
		when: StSpotterAllCandidatesAdded send: #announceAllCandidatesAdded: to: self;
		when: StSpotterCandidatesAmountChanged send: #announceAmountChanged: to: self;
		when: StSpotterQueryStarted send: #announceQueryStarted: to: self;
		when: StSpotterQueryEnded send: #announceQueryEnded: to: self.
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

{ #category : #'private processing' }
StSpotterModel >> ensureWorkerRunning [

	(worker isNotNil and: [ worker isTerminated not ])
		ifTrue: [ ^ self ].

	workerSemaphore := Semaphore new.
	worker := [
		[ true ] whileTrue: [
			requestedText ifNotNil: [ 
				self process: requestedText.
				requestedText := nil ].
			workerSemaphore wait ] 
	] 
	forkAt: Processor lowIOPriority 
	named: 'Spotter Worker'
]

{ #category : #initialization }
StSpotterModel >> initialize [

	super initialize.
	mutex := Mutex new.
	queries := OrderedCollection new
]

{ #category : #accessing }
StSpotterModel >> links [

	^ activeQuery 
		ifNotNil: [ :aQuery | aQuery links ]
		ifNil: [ #() ]
]

{ #category : #'private processing' }
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

{ #category : #private }
StSpotterModel >> refreshQueryStatus: aQuery [

	aQuery links ifEmpty: [ ^ self ].

	self announceAllCandidatesAdded: (StSpotterAllCandidatesAdded new
		candidateLinks: aQuery links;
		yourself).

	aQuery isFinished ifTrue: [ 
		self announceAmountChanged: (StSpotterCandidatesAmountChanged new 
			amount: aQuery links size;
			yourself) ]
]

{ #category : #accessing }
StSpotterModel >> results [

	^ activeQuery 
		ifNotNil: [ :aQuery | aQuery results ]
		ifNil: [ #() ]
]

{ #category : #processing }
StSpotterModel >> startProcessing [

	self ensureWorkerRunning.
	self asyncProcess: ''
]

{ #category : #processing }
StSpotterModel >> stopProcessing [

	worker terminate
	
]

{ #category : #'private processing' }
StSpotterModel >> triggerWorker [

	workerSemaphore signal
]

{ #category : #events }
StSpotterModel >> whenAmountChangedDo: aBlock [

	amountChangedAction := aBlock
]

{ #category : #events }
StSpotterModel >> whenQueryEndedDo: aBlock [

	queryEndedAction := aBlock
]

{ #category : #events }
StSpotterModel >> whenQueryStartedDo: aBlock [

	queryStartedAction := aBlock
]

{ #category : #events }
StSpotterModel >> whenSearchUpdatedDo: aBlock [

	searchUpdatedAction := aBlock
]
