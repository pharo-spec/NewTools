Extension { #name : 'StClassEntry' }

{ #category : '*NewTools-Pulse' }
StClassEntry >> accept: aSpotter [

	aSpotter visitClassEntry: self
]

{ #category : '*NewTools-Pulse' }
StClassEntry >> categoryLabel [

	^ 'class'
]
