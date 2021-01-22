Extension { #name : #Object }

{ #category : #'*NewTools-Spotter' }
Object >> asStSpotterProcessorLink [

	^ StSpotterProcessorLink value: self
]

{ #category : #'*NewTools-Spotter' }
Object >> spotterPreview: aBuilder [

	^ self asString spotterPreview: aBuilder
]
