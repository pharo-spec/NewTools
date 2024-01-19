Extension { #name : 'Package' }

{ #category : '*NewTools-Spotter-Extensions' }
Package >> spotterClassesFor: aStep [
	<stSpotterOrder: 20>
	aStep listProcessor
			allCandidates: [ self definedClasses sorted: [ :a :b | a name < b name ] ];
			title: 'Classes';
			filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Package >> spotterExtensionMethodsFor: aStep [
	<stSpotterOrder: 30>
	aStep listProcessor
			allCandidates: [ self extensionMethods ];
			title: 'Extension Methods';
			filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Package >> spotterMonticelloPackageFor: aStep [
	<stSpotterOrder: 41>
	
	aStep listProcessor
		title: 'Monticello Package';
		allCandidates: [ self mcPackage 
			ifNotNil: [ :mcPackage | Array with: mcPackage ] 
			ifNil: [ #() ] ];
		itemIconName: [ :item | #monticelloPackageIcon ];
		filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Package >> spotterMonticelloWorkingCopyFor: aStep [
	<stSpotterOrder: 42>
	aStep listProcessor
		title: 'Monticello Working Copy';
		allCandidates: [ self mcPackage 
			ifNotNil: [ :mcPackage | Array with: mcPackage workingCopy ] 
			ifNil: [ #() ] ];
		itemIconName: [ :item | #versionControl ];
		filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Package >> spotterTagsFor: aStep [
	<stSpotterOrder: 20>
	self classTags size <= 1 ifTrue: [ ^ self ].
	aStep listProcessor
			allCandidates: [ self classTags sorted: [ :a :b | a name < b name ] ];
			title: 'Tags';
			itemName: [ :item | item name ];
			filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Package >> stActDefault [

	^ Smalltalk tools browser openOnPackage: self
]
