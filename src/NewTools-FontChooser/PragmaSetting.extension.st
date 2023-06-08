Extension { #name : #PragmaSetting }

{ #category : #'*NewTools-FontChooser' }
PragmaSetting >> getFont [

	| chooser |
	chooser := FontChooser
		openModalWithTitle: 'Font for ' , self name
		initialFont: self realValue
		onAcceptDo: [ :e | self realValue: e ].

	^ chooser font.

]
