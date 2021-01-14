Class {
	#name : #StSpotterQuery,
	#superclass : #Object,
	#instVars : [
		'text',
		'candidatesList',
		'processors',
		'results'
	],
	#category : #'NewTools-Spotter'
}

{ #category : #'instance creation' }
StSpotterQuery class >> on: aString [

	^ self new 
		text: aString; 
		yourself
]

{ #category : #private }
StSpotterQuery >> allCandidatesAdded: ann [
	
	ann candidateLinks ifEmpty: [ ^ self ].
	ann candidateLinks 
		collect: [ :each | each value ]
		thenDo: [ :each | results add: each ]
]

{ #category : #accessing }
StSpotterQuery >> announcer [

	^ self candidatesList announcer
]

{ #category : #private }
StSpotterQuery >> candidateAdded: ann [

	results add: ann candidate
	
]

{ #category : #accessing }
StSpotterQuery >> candidatesList [

	^ candidatesList
]

{ #category : #accessing }
StSpotterQuery >> candidatesList: anObject [

	candidatesList := anObject
]

{ #category : #accessing }
StSpotterQuery >> defaultProcessors [

	^ (AbstractSpotterProcessor allEnabledSubclasses 
		collect: [ :each | each new ])
		sort: #order ascending
]

{ #category : #initialization }
StSpotterQuery >> initialize [

	super initialize.
	self initializeCandidatesList.
	results := Set new
]

{ #category : #initialization }
StSpotterQuery >> initializeCandidatesList [

	candidatesList := GTSpotterCandidatesList new.
	candidatesList announcer 
		when: GTSpotterCandidateAdded send: #candidateAdded: to: self;
		when: GTSpotterAllCandidatesAdded send: #allCandidatesAdded: to: self.
		"when: GTSpotterAllCandidatesRemoved do: [ self deselect ];
		when: GTSpotterQueryStarted send: #propagateEvent: to: self;
		when: GTSpotterQueryEnded send: #propagateEvent: to: self."

]

{ #category : #'private factory' }
StSpotterQuery >> newContextFor: aStream text: aString [

	^ GTSpotterContext new 
		step: self;
		stream: aStream;
		text: aString;
		search: aString;
		yourself
]

{ #category : #'private factory' }
StSpotterQuery >> newStreamFor: candidates [

	^ StSpotterStream new
		onAddedSelector: #addCandidate:in:;
		onRemoveSelector: #removeAllCandidatesOf:;
		receiver: candidates;
		yourself
]

{ #category : #processing }
StSpotterQuery >> process [ 
	| context stream |

	stream := self newStreamFor: candidatesList.
	context := self newContextFor: stream text: self text.
	
	self processors
		do: [ :each | each filterInContext: context ]
]

{ #category : #accessing }
StSpotterQuery >> processors [

	^ processors ifNil: [ processors := self defaultProcessors ]
]

{ #category : #accessing }
StSpotterQuery >> results [

	^ results
]

{ #category : #accessing }
StSpotterQuery >> text [

	^ text
]

{ #category : #accessing }
StSpotterQuery >> text: anObject [

	text := anObject
]
