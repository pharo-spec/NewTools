Extension { #name : 'Behavior' }

{ #category : '*NewTools-Spotter-Extensions' }
Behavior >> spotterClassInstanceVariablesFor: aStep [
	<stSpotterOrder: 25>
	self isTrait
		ifTrue: [ ^ self ].
	aStep listProcessor
		title: 'Class instance variables';
		allCandidates: [ self class classLayout allSlots ];
		itemName: [ :each | each name asString ];
		filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Behavior >> spotterCompositionFor: aStep [
	<stSpotterOrder: 25>

	aStep listProcessor
			title: 'Composing traits';
			allCandidates: [ self allTraits ];
			itemIconName: [ :item | item systemIconName ];
			filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Behavior >> spotterInstanceVariablesFor: aStep [
	<stSpotterOrder: 20>
	self isTrait
		ifTrue: [ ^ self ].
	aStep listProcessor
		title: 'Instance variables';
		allCandidates: [ self classLayout allSlots ];
		itemName: [ :each | each name asString ];
		filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Behavior >> spotterSubclassesFor: aStep [
	<stSpotterOrder: 50>
	aStep listProcessor
			title: 'All subclasses';
			allCandidates: [ self allSubclasses ];
			itemIconName: [ :item | item systemIconName ];
			filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Behavior >> spotterSuperclassesFor: aStep [
	<stSpotterOrder: 40>
	
	aStep listProcessor
			title: 'All superclasses';
			allCandidates: [ self allSuperclasses ];
			itemIconName: [ :item | item systemIconName ];
			filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Behavior >> spotterTraitUsersFor: aStep [
	<stSpotterOrder: 20>
	self isTrait ifFalse: [ ^ self ].
	aStep listProcessor
			title: 'Users';
			allCandidates: [ self users asArray ];
			itemIconName: [ :item | item systemIconName ];
			filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Behavior >> spotterUsedSlotsFor: aStep [
	<stSpotterOrder: 70>
	aStep listProcessor
			title: 'Full Definition Slots';
			allCandidates: [ self slots select: [ :slot | slot needsFullDefinition ] ];
			itemName: [ :item | item definitionString ];
			filter: StFilterSubstring
]

{ #category : '*NewTools-Spotter-Extensions' }
Behavior >> spotterUsedTraitsFor: aStep [
	<stSpotterOrder: 60>
	
	aStep listProcessor
			title: 'Uses Traits';
			allCandidates: [ self traits asArray ];
			itemIconName: [ :item | item systemIconName ];
			filter: StFilterSubstring
]
