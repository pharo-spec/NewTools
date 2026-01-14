Extension { #name : 'SpMorphicBaseTextAdapter' }

{ #category : '*NewTools-SpTextPresenterDecorators' }
SpMorphicBaseTextAdapter >> addTextSegmentDecoration: aDecorationSegment [

	self widgetDo: [ :w |
			| morph |
			morph := (RubUnderlinedSegmentMorph from: aDecorationSegment start to: aDecorationSegment stop)
				         color: aDecorationSegment highlightColor;
				         underlineColor: aDecorationSegment underlineColor;
				         icon: aDecorationSegment icon;
				         iconBlock: aDecorationSegment iconBlock;
				         label: aDecorationSegment title;
				         yourself.

			w addSegment: morph.
			w withTextSegmentIcons ]
]

{ #category : '*NewTools-SpTextPresenterDecorators' }
SpMorphicBaseTextAdapter >> removeAllTextSegmentDecorations [
	
	self widgetDo: [ :w | 
		w segments copy do: [ :each |
			w textArea
				removeSegment: each;
				removeMorph: each ] ]
]
