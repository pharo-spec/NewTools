Extension { #name : #SpMorphicBaseTextAdapter }

{ #category : #'*NewTools-SpTextPresenterDecorators' }
SpMorphicBaseTextAdapter >> addTextSegmentDecoration: aDecorationSegment [
	self widget addSegment: aDecorationSegment
]

{ #category : #'*NewTools-SpTextPresenterDecorators' }
SpMorphicBaseTextAdapter >> widget [
	^widget
]

{ #category : #'*NewTools-SpTextPresenterDecorators' }
SpMorphicBaseTextAdapter >> widget: aWidget [
	widget := aWidget
]
