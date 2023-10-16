Extension { #name : 'SettingNode' }

{ #category : '*NewTools-Spotter-Extensions' }
SettingNode >> spotterForSettingsFor: aStep [
	<stSpotterOrder: 0>
	self allChildren isEmpty ifTrue: [ ^ self ].
	aStep listProcessor
		title: 'Children';
		allCandidates: [ self allChildren ];
		itemName: [ :each | each spotterLabel ];
		filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
SettingNode >> spotterLabel [

	| label |
	label := self settingDeclaration label.
	^ self parentNode ifNil: [ label ] ifNotNil: [ self parentNode spotterLabel , '/' , label ]
]
