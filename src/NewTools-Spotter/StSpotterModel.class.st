Class {
	#name : #StSpotterModel,
	#superclass : #Object,
	#instVars : [
		'runner',
		'processors',
		'candidateAddedAction',
		'searchUpdatedAction',
		'results'
	],
	#category : #'NewTools-Spotter'
}

{ #category : #private }
StSpotterModel >> allCandidatesAdded: ann [
	
	ann candidateLinks ifEmpty: [ ^ self ].
	ann candidateLinks 
		collect: [ :each | each value ]
		thenDo: [ :each | 
			(results includes: each) 
				ifFalse: [ results add: each ] ].
		
	self announceSearchUpdated
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

{ #category : #private }
StSpotterModel >> candidateAdded: ann [
	| candidate |
	
	candidate := ann candidate.
	(results includes: candidate) ifTrue: [ ^ self ].
	results add: candidate.
	self announceSearchUpdated
	
]

{ #category : #accessing }
StSpotterModel >> defaultProcessors [

	^ (AbstractSpotterProcessor allEnabledSubclasses 
		collect: [ :each | 
			each new
				"missing this thingy (probably not needed)"
				"configureOn: aSpotterStep;
				yourself" ])
		sort: #order ascending
]

{ #category : #initialization }
StSpotterModel >> initialize [

	super initialize.
	results := Set new
]

{ #category : #'private factory' }
StSpotterModel >> newContextFor: aStream text: aString [

	^ GTSpotterContext new 
		step: self;
		stream: aStream;
		text: aString;
		search: aString;
		yourself
]

{ #category : #'private factory' }
StSpotterModel >> newStreamFor: candidates [

	^ StSpotterStream new
		onAddedSelector: #addCandidate:in:;
		onRemoveSelector: #removeAllCandidatesOf:;
		receiver: candidates;
		yourself
]

{ #category : #processing }
StSpotterModel >> process: aString [
	| candidates stream context |
		
	candidates := GTSpotterCandidatesList new.
	candidates announcer 
		when: GTSpotterCandidateAdded send: #candidateAdded: to: self;
		when: GTSpotterAllCandidatesAdded send: #allCandidatesAdded: to: self.
		"when: GTSpotterAllCandidatesRemoved do: [ self deselect ];
		when: GTSpotterQueryStarted send: #propagateEvent: to: self;
		when: GTSpotterQueryEnded send: #propagateEvent: to: self."

	stream := self newStreamFor: candidates.
	context := self newContextFor: stream text: aString.
	
	self processors
		do: [ :each | each filterInContext: context ]
]

{ #category : #accessing }
StSpotterModel >> processors [

	^ processors ifNil: [ processors := self defaultProcessors ]
]

{ #category : #accessing }
StSpotterModel >> results [

	^ results
]

{ #category : #events }
StSpotterModel >> whenSearchUpdatedDo: aBlock [

	searchUpdatedAction := aBlock
]
