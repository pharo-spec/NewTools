Extension { #name : 'StNewSettingsTree' }

{ #category : '*NewTools-Spotter-Extensions' }
StNewSettingsTree >> spotterForSettingsFor: aStep [
	<stSpotterOrder: 0>
	aStep listProcessor
		title: 'Settings';
		allCandidates: [ self nodeList ];
		itemName: [ :each | each spotterLabel ];
		filter: StFilterSubstring
]
