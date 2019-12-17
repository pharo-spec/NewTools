Extension { #name : #SpMorphicBaseTextAdapter }

{ #category : #'*NewTools-SpTextPresenterDecorators' }
SpMorphicBaseTextAdapter >> addTextSegmentDecoration: aDecorationSegment [
	self widget addSegment:
		(RubUnderlinedSegmentMorph on: aDecorationSegment)
]
