Extension { #name : 'StEntry' }

{ #category : '*NewTools-Pulse' }
StEntry >> accept: aSpotter [

	aSpotter visitWindowEntry: self
]

{ #category : '*NewTools-Pulse' }
StEntry >> categoryLabel [

	^ self subclassResponsibility
]
