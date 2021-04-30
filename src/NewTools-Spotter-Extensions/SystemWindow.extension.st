Extension { #name : #SystemWindow }

{ #category : #'*NewTools-Spotter-Extensions' }
SystemWindow >> spotterWindowsFor: aStep [
	<stSpotterOrder: 100>

	aStep listProcessor
			title: 'Windows';
			allCandidates: [ self class allSubInstances ];
			itemName: [ :window | '**', window label, '**' ];
			filter: StFilterSubstring
]

{ #category : #'*NewTools-Spotter-Extensions' }
SystemWindow >> stActDefault [
	self method compiledMethod browse
]
