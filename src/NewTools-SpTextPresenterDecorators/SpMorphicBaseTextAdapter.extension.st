Extension { #name : #SpMorphicBaseTextAdapter }

{ #category : #'*NewTools-SpTextPresenterDecorators' }
SpMorphicBaseTextAdapter >> addTextSegmentDecoration: aDecorationSegment [
	
	self widgetDo: [ :w | 
		w addSegment: (RubUnderlinedSegmentMorph on: aDecorationSegment) ]
]

{ #category : #'*NewTools-SpTextPresenterDecorators' }
SpMorphicBaseTextAdapter >> removeAllTextSegmentDecorations [
	
	self widgetDo: [ :w | 
		w segments do: [ :each | w textArea removeSegment: each ] ]
]
