Extension { #name : 'GraphicFontSettings' }

{ #category : '*NewTools-FontChooser' }
GraphicFontSettings class >> pickFont [

	FontChooser
		openModalWithTitle: 'Font for all font'
		initialFont: StandardFonts defaultFont
		onAcceptDo: [ :aFont | self resetAllFontsTo: aFont ]
]
