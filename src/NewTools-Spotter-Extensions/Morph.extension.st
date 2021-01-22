Extension { #name : #Morph }

{ #category : #'*NewTools-Spotter-Extensions' }
Morph >> spotterPreview: aBuilder [

	^ aBuilder newImage 
		image: (self asFormOfSize: 300@300);
		yourself
]
