Extension { #name : 'Context' }

{ #category : '*NewTools-Inspector-Extensions' }
Context >> inspectionSelectors: aBuilder [
	<inspectorPresentationOrder: 909 title: 'Senders'>
	| senders aSender |
	
	senders := OrderedCollection new.
	aSender := self.
	[ aSender isNotNil ] whileTrue: [
		senders add: aSender.
		aSender := aSender sender ].

	^ aBuilder newList
		addStyle: 'stList';
		items: senders;
		display: [ :aContext | aContext homeMethod name ];
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
Context >> inspectionSource: aBuilder [
	<inspectorPresentationOrder: 910 title: 'Method Source'>

	^ self sourceNode inspectionSource: aBuilder
]
