Extension { #name : 'Setting' }

{ #category : '*NewTools-FontChooser' }
Setting >> getFont [
	"Let the user choose a new font value for the receiver"

	| chooser |
	chooser := FontChooser
		openModalWithTitle: 'Font for ' , self name
		initialFont: self realValue
		onAcceptDo: [ :e | self realValue: e ].

	^ chooser font
]
