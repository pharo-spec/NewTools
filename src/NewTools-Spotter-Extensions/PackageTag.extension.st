Extension { #name : 'PackageTag' }

{ #category : '*NewTools-Spotter-Extensions' }
PackageTag >> spotterClassesFor: aStep [
	<stSpotterOrder: 20>
	aStep listProcessor
			allCandidates: [ self classes sorted: [ :a :b | a name < b name ] ];
			title: 'Classes';
			filter: StFilterSubstring
]
