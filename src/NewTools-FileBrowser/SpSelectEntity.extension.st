Extension { #name : #SpSelectEntity }

{ #category : #'*NewTools-FileBrowser' }
SpSelectEntity class >> fDLayoutFileDialog [
	^ SpBoxLayout newVertical
		add: #entityText;
		yourself
]
