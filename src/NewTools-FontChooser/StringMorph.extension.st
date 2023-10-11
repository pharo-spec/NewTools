Extension { #name : 'StringMorph' }

{ #category : '*NewTools-FontChooser' }
StringMorph >> changeFont [

	FontChooser 
		openModalWithTitle: 'Choose a Font' 
		initialFont: (self fontToUse) 
		onAcceptDo: [ :e | self font: e ].
]
