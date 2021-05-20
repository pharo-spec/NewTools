Extension { #name : #MCVersionInfo }

{ #category : #'*NewTools-Spotter-Extensions' }
MCVersionInfo >> allAncestors [
	^ (self allAncestorsTo: OrderedCollection new)
		sort: [ :a :b | a timeStamp >= b timeStamp ]
]

{ #category : #'*NewTools-Spotter-Extensions' }
MCVersionInfo >> allAncestorsTo: aCollection [
	self ancestors do: [ :versionInfo | 
		" do not add/process ancestry-branches which have already been added/processed "
		(aCollection includes: versionInfo) ifFalse: [ 
			aCollection add: versionInfo.
			versionInfo allAncestorsTo: aCollection ] ].
	^ aCollection
]

{ #category : #'*NewTools-Spotter-Extensions' }
MCVersionInfo >> spotterAncestorsFor: aStep [
	<stSpotterOrder: 1>
	self flag: 'rewrite for direct streaming - get rid of recursion'.
	aStep listProcessor
		title: 'Ancestors';
		allCandidates: [ self allAncestors ];
		filter: StFilterSubstring
]
