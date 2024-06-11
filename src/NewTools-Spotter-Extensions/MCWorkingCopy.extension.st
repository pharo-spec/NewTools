Extension { #name : 'MCWorkingCopy' }

{ #category : '*NewTools-Spotter-Extensions' }
MCWorkingCopy >> spotterAncestorsFor: aStep [
	<stSpotterOrder: 2>
	self flag: #maybeRewriteForDirectStreaming.
	aStep listProcessor
		title: 'Ancestors';
		allCandidates: [ self allAncestors ];
		filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
MCWorkingCopy >> spotterMonticelloPackageFor: aStep [
	<stSpotterOrder: 21>
	
	aStep listProcessor
		title: 'Monticello Package';
		allCandidates: [ Array with: self package ];
		itemIconName: [ :item | #monticelloPackageIcon ];
		filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
MCWorkingCopy >> spotterPackageFor: aStep [
	<stSpotterOrder: 21>
	self flag: #maybeRewriteForDirectStreaming.

	aStep listProcessor
		title: 'Packages';
		allCandidates: [ self package systemPackage 
			ifNotNil: [ :rpackage | { rpackage } ] 
			ifNil: [ { } ] ];
		itemName: [ :item | item name ];
		itemIconName: [ :item | #package ];
		filter: StFilterSubstring
]
