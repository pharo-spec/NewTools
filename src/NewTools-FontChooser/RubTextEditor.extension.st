Extension { #name : 'RubTextEditor' }

{ #category : '*NewTools-FontChooser' }
RubTextEditor >> changeTextFont [
	"Present a menu of available fonts, and if one is chosen, apply it to the current selection."

	textArea
		forceCursorVisibleWhile: [ 
			| hadFocus |
			hadFocus := textArea hasFocus.
			
			FontChooser 
				openModalWithTitle: 'Choose a Font' 
				initialFont: (self fontToUse) 
				onAcceptDo: [ :e | self applyTextFont: e ].			

			hadFocus
				ifTrue: [ textArea takeKeyboardFocus ] ]
]
