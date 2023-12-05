Extension { #name : 'Package' }

{ #category : '*NewTools-Inspector-Extensions' }
Package >> baselineInspector [

	<inspectorPresentationOrder: 2 title: 'Belongs to Baselines'>
	| items |
	items := BaselineOf allSubclasses select: [ :e | e allPackageNames includes: self name ].
	^ SpListPresenter new
		items: items;
		yourself
]
