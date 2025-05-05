Extension { #name : 'Morph' }

{ #category : '*NewTools-Morphic' }
Morph >> inspectionLayout [
	<inspectorPresentationOrder: 800 title: 'Layout'>
	
	^ SpTablePresenter new 
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
Morph >> inspectionMorph [
	<inspectorPresentationOrder: 90 title: 'Morph'>

	^ SpMorphPresenter new
		morph: self imageForm asMorph;
		yourself
]

{ #category : '*NewTools-Morphic' }
Morph >> inspectorIconName [

	^ self class systemIconName
]
