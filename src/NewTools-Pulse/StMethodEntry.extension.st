Extension { #name : 'StMethodEntry' }

{ #category : '*NewTools-Pulse' }
StMethodEntry >> accept: aSpotter [

	aSpotter visitMethodEntry: self
]

{ #category : '*NewTools-Pulse' }
StMethodEntry >> categoryLabel [

	^ 'method'
]
