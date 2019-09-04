Extension { #name : #SpSelectEntity }

{ #category : #'*NewTools-FileDialog' }
SpSelectEntity class >> fDLayoutFileDialog [
	^ SpBoxLayout newVertical
		add: #entityText;
		yourself
]
