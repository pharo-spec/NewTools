Extension { #name : 'StNewSettingNode' }

{ #category : '*NewTools-Spotter-Extensions' }
StNewSettingNode >> spotterForSettingsFor: aStep [
	<stSpotterOrder: 0>
	self allChildren isEmpty ifTrue: [ ^ self ].
	aStep listProcessor
		title: 'Children';
		allCandidates: [ self allChildren ];
		itemName: [ :each | each spotterLabel ];
		filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
StNewSettingNode >> spotterLabel [

	^ self parentNode
		  ifNil: [ self label ]
		  ifNotNil: [ :parent | parent spotterLabel , '/' , self label ]
]
