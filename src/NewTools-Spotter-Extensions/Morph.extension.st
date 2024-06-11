Extension { #name : 'Morph' }

{ #category : '*NewTools-Spotter-Extensions' }
Morph >> spotterForSubmorphsFor: aStep [
	<stSpotterOrder: 10>
	self submorphs ifNil: [ ^ self ].
	
	aStep listProcessor
			title: 'Submorphs';
			allCandidates: [ self submorphs ];
			candidatesLimit: 5;
			filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Morph >> spotterPreview: aBuilder [

	^ aBuilder newImage 
		image: (self asFormOfSize: 300@300);
		yourself
]
