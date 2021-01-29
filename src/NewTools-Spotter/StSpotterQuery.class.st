Class {
	#name : #StSpotterQuery,
	#superclass : #Object,
	#instVars : [
		'text',
		'connected',
		'candidatesList',
		'processors',
		'candidateLinks'
	],
	#category : #'NewTools-Spotter-Model'
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
	candidateLinks addAll: ann candidateLinks
]

{ #category : #accessing }
StSpotterQuery >> announcer [

	^ self candidatesList announcer
]

{ #category : #private }
StSpotterQuery >> candidateAdded: ann [

	candidateLinks add: ann candidateLink
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
StSpotterQuery >> connect [

	connected := true
]

{ #category : #accessing }
StSpotterQuery >> disconnect [

	connected := false
]

{ #category : #initialization }
StSpotterQuery >> initialize [

	super initialize.
	self initializeCandidatesList.
	candidateLinks := Set new.
	connected := false
]

{ #category : #initialization }
StSpotterQuery >> initializeCandidatesList [

	candidatesList := StSpotterCandidatesList new.
	candidatesList announcer 
		when: StSpotterCandidateAdded send: #candidateAdded: to: self;
		when: StSpotterAllCandidatesAdded send: #allCandidatesAdded: to: self.
		"when: GTSpotterAllCandidatesRemoved do: [ self deselect ];
		when: GTSpotterQueryStarted send: #propagateEvent: to: self;
		when: GTSpotterQueryEnded send: #propagateEvent: to: self."

]

{ #category : #testing }
StSpotterQuery >> isConnected [

	^ connected
]

{ #category : #accessing }
StSpotterQuery >> links [

	^ candidateLinks
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

	^ processors
]

{ #category : #accessing }
StSpotterQuery >> processors: aCollection [

	processors := aCollection
]

{ #category : #accessing }
StSpotterQuery >> results [

	^ self links collect: [ :each | each value ]
]

{ #category : #accessing }
StSpotterQuery >> text [

	^ text
]

{ #category : #accessing }
StSpotterQuery >> text: anObject [

	text := anObject
]
