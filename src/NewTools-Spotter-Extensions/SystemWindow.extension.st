Extension { #name : 'SystemWindow' }

{ #category : '*NewTools-Spotter-Extensions' }
SystemWindow >> stActDefault [

	^ self isTopWindow
		ifTrue: [ self comeToFront ] "rise above non-window morphs"
		ifFalse:[ self restoreAndActivate ]
]

{ #category : '*NewTools-Spotter-Extensions' }
SystemWindow >> stWindowsFor: aStep [
	<stSpotterOrder: 100>

	aStep listProcessor
			title: 'Windows';
			allCandidates: [ self class allSubInstances ];
			itemName: [ :window | '**', window label, '**' ];
			filter: StFilterSubstring
]
