Extension { #name : 'StSettingsTree' }

{ #category : '*NewTools-Spotter-Extensions' }
StSettingsTree >> spotterForSettingsFor: aStep [
	<stSpotterOrder: 0>
	aStep listProcessor
		title: 'Settings';
		allCandidates: [ self nodeList ];
		itemName: [ :each | each spotterLabel ];
		filter: StFilterSubstring
]
