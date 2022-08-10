Extension { #name : #StInspector }

{ #category : #'*NewTools-FileBrowser' }
StInspector class >> instanciateOn: anObject [
	^ self on: (StInspectorModel on: anObject)
]
