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

{ #category : '*NewTools-Inspector-Extensions' }
Package >> overwiew [

	<inspectorPresentationOrder: 1 title: 'Overwiew'>
	| items |
	items :={ 'Classes' -> self classes . 'Defined classes' -> self definedClasses . 'Methods' -> self methods }.
	items := items collect: [ :e | StInspectorAssociationNode hostObject: e ].
	^ SpTablePresenter new
		alternateRowsColor;
		items: items;
		addColumn: (SpStringTableColumn
			title: 'Title'
			evaluated: [ :e | e key ] );
		addColumn: (SpStringTableColumn
			title: 'Value'
			evaluated: [ :e | e value size ] );
		yourself
]
