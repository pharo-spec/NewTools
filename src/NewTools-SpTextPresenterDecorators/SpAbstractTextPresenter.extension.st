Extension { #name : 'SpAbstractTextPresenter' }

{ #category : '*NewTools-SpTextPresenterDecorators' }
SpAbstractTextPresenter >> addTextSegmentDecoration: aDecorationSegment [

	self withAdapterPerformOrDefer: [ :anAdapter | 
		anAdapter addTextSegmentDecoration: aDecorationSegment ]
]

{ #category : '*NewTools-SpTextPresenterDecorators' }
SpAbstractTextPresenter >> removeAllTextSegmentDecorations [

	self withAdapterDo: [ :anAdapter | 
		anAdapter removeAllTextSegmentDecorations ]
]
