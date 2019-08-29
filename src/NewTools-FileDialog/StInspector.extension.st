Extension { #name : #StInspector }

{ #category : #'*NewTools-FileDialog' }
StInspector class >> instanciateOn: anObject [
	^ self on: (StInspectorModel on: anObject)
]
