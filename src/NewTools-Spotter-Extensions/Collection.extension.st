Extension { #name : #Collection }

{ #category : #'*NewTools-Spotter-Extensions' }
Collection >> spotterItemsFor: aStep [
	<stSpotterOrder: 10>
	| processor |

	(self isEmpty or: [ self size > self collectionSizeThreshold ]) ifTrue: [ ^ self ].
	processor := aStep previousProcessorFrom: self.
	^ aStep listProcessor
		title: processor title;
		candidatesLimit: StSpotterPragmaBasedProcessor defaultNestedItemsLimit;
		items: [ self collect: [ :each | each asStSpotterCandidateLink value ] as: OrderedCollection ];
		itemName: processor itemName;
		itemIconName: processor itemIconName;
		actLogic: processor actLogic; 
		filter: processor filter stListFilter;
		wantsToDisplayOnEmptyQuery: true
]
