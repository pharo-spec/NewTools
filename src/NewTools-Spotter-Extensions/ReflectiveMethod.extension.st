Extension { #name : 'ReflectiveMethod' }

{ #category : '*NewTools-Spotter-Extensions' }
ReflectiveMethod >> spotterForImplementorsFor: aStep [
	<stSpotterOrder: 10>
	self compiledMethod spotterForImplementorsFor: aStep
]

{ #category : '*NewTools-Spotter-Extensions' }
ReflectiveMethod >> spotterForSendersFor: aStep [
	<stSpotterOrder: 11>
	self compiledMethod spotterForSendersFor: aStep
]

{ #category : '*NewTools-Spotter-Extensions' }
ReflectiveMethod >> spotterMethodClassFor: aStep [
	<stSpotterOrder: 50>
	self compiledMethod spotterMethodClassFor: aStep
]
