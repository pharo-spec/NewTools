Extension { #name : 'MCWorkingCopy' }

{ #category : '*NewTools-Spotter-Extensions' }
MCWorkingCopy >> spotterAllRepositoriesFor: aStep [
	<stSpotterOrder: 20>
	aStep listProcessor
		title: 'All other repositories';
		allCandidates: [ MCRepositoryGroup default repositories \ self repositoryGroup repositories ];
		itemName: [ :item | item description ];
		actLogic: [ :item :step | 
			step exit.
			self spotterCommit: self in: item ];
		filter: StFilterSubstring
]

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
MCWorkingCopy >> spotterCommit: workingCopy in: aRepository [
	| newVersion |

	newVersion := workingCopy newVersionIn: aRepository.
	newVersion ifNil: [ ^ self ].
	Cursor wait showWhile: [
		[ 	aRepository storeVersion: newVersion.
			aRepository storeDependencies: newVersion ] 
		ensure: [ (MCVersionInspector new version: newVersion) show ]]
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
		allCandidates: [ self package correspondingRPackage 
			ifNotNil: [ :rpackage | { rpackage } ] 
			ifNil: [ { } ] ];
		itemName: [ :item | item name ];
		itemIconName: [ :item | #package ];
		filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
MCWorkingCopy >> spotterPackageRepositoriesFor: aStep [
	<stSpotterOrder: 10>
	aStep listProcessor
		title: 'Package repositories';
		allCandidates: [ self repositoryGroup repositories ];
		itemName: [ :item | item description ];
		actLogic: [ :item :step |
			step exit.
			self spotterCommit: self in: item ];
		filter: StFilterSubstring
]
