Extension { #name : 'Package' }

{ #category : '*NewTools-Inspector-Extensions' }
Package >> inspectionBaselineInspector: aBuilder [
	<inspectorPresentationOrder: 2 title: 'Belongs to Baselines'>
	| items |

	items := BaselineOf allSubclasses select: [ :e | e allPackageNames includes: self name ].
	^ aBuilder newList
		addStyle: 'stList';
		items: items;
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
Package >> inspectionOverwiew: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Overwiew'>
	| items |
	
	items :={ 'Classes' -> self classes . 'Defined classes' -> self definedClasses . 'Methods' -> self methods }.
	items := items collect: [ :e | StInspectorAssociationNode hostObject: e ].
	^ aBuilder newTable
		addStyle: 'stList';
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
