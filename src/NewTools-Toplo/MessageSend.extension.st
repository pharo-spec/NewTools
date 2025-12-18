Extension { #name : 'MessageSend' }

{ #category : '*NewTools-Toplo' }
MessageSend >> ensure: aBlock [

	^ [ self value ] ensure: aBlock
]
