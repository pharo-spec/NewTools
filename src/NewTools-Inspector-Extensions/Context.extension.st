Extension { #name : 'Context' }

{ #category : '*NewTools-Inspector-Extensions' }
Context >> inspectionSelectors [

	<inspectorPresentationOrder: 909 title: 'Senders'>
	| senders aSender |
	senders := OrderedCollection new.
	aSender := self.
	[ aSender isNotNil ] whileTrue: [
		senders add: aSender.
		aSender := aSender sender ].

	^ SpListPresenter new
		  items: senders;
		  display: [ :aContext | aContext homeMethod name ];
		  yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
Context >> inspectionSource [
	<inspectorPresentationOrder: 910 title: 'Method Source'>

	^ self sourceNode inspectionSource
]
