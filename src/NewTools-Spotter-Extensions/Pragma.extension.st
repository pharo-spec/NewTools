Extension { #name : 'Pragma' }

{ #category : '*NewTools-Spotter-Extensions' }
Pragma >> spotterForImplementorsFor: aStep [
	<stSpotterOrder: 10>
	self method spotterForImplementorsFor: aStep
]

{ #category : '*NewTools-Spotter-Extensions' }
Pragma >> spotterForSendersFor: aStep [
	<stSpotterOrder: 10>
	self method spotterForSendersFor: aStep
]

{ #category : '*NewTools-Spotter-Extensions' }
Pragma >> stActDefault [
    ^ self method browse
]
