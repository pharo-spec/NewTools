Extension { #name : 'UITheme' }

{ #category : '*NewTools-FontChooser' }
UITheme >> chooseFontIn: aThemedMorph title: aString font: aFont [
	"Answer the result of a font selector dialog with the given title and initial font."

	| selectedFont |

	FontChooser 
		openModalWithTitle: aString 
		initialFont: aFont
		onAcceptDo: [ :e | selectedFont := e ].			
	
	^ selectedFont
]
