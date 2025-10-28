Extension { #name : 'Morph' }

{ #category : '*NewTools-Morphic' }
Morph >> application [

	^ self 
		valueOfProperty: #application 
		ifAbsent: [ 
			self owner 
				ifNotNil: [ self owner application ]
				ifNil: [ StPharoApplication current ] ]
]

{ #category : '*NewTools-Morphic' }
Morph >> application: anApplication [

	^ self 
		setProperty: #application 
		toValue: anApplication
]

{ #category : '*NewTools-Morphic' }
Morph >> inspectionLayout: aBuilder [
	<inspectorPresentationOrder: 800 title: 'Layout'>
	
	^ aBuilder newTable 
		addColumn: (SpStringTableColumn title: 'Property' evaluated: [ :assoc | assoc key ]);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: [ :assoc | assoc value ]);
		items: { 
			'layoutPolicy' -> self layoutPolicy ifNil: [ 'None' ].
			'extent' -> self extent.
			'hResizing' -> self hResizing.
			'vResizing' -> self vResizing.
			'cellInset' -> self cellInset.
			'cellPositioning' -> self cellPositioning.
			'cellSpacing' -> self cellSpacing.
			'layoutInset' -> self layoutInset.
			'listCentering' -> self listCentering.
			'listDirection' -> self listDirection.
			'listSpacing' -> self listSpacing.
			'maxCellSize' -> (self maxCellSize = SmallInteger maxVal 
				ifTrue: [ 'Infinite' ] 
				ifFalse: [ self maxCellSize ]). 
			'minCellSize' -> self minCellSize.
			'reverseTableCells' -> self reverseTableCells.
			'rubberBandCells' -> self rubberBandCells.
			'wrapCentering' -> self wrapCentering.
			'wrapDirection' -> self wrapDirection.
			};
		yourself
]

{ #category : '*NewTools-Morphic' }
Morph >> inspectionMorph: aBuilder [
	<inspectorPresentationOrder: 90 title: 'Morph'>

	^ aBuilder newMorph
		morph: self imageForm asMorph;
		yourself
]

{ #category : '*NewTools-Morphic' }
Morph >> inspectorIconName [

	^ self class systemIconName
]
