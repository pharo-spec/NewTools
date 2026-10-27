Extension { #name : 'StSettingNode' }

{ #category : '*NewTools-Spotter-Extensions' }
StSettingNode >> spotterForSettingsFor: aStep [
	<stSpotterOrder: 0>
	self allChildren isEmpty ifTrue: [ ^ self ].
	aStep listProcessor
		title: 'Children';
		allCandidates: [ self allChildren ];
		itemName: [ :each | each spotterLabel ];
		filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
StSettingNode >> spotterLabel [

	^ self parentNode
		  ifNil: [ self label ]
		  ifNotNil: [ :parent | parent spotterLabel , '/' , self label ]
]
