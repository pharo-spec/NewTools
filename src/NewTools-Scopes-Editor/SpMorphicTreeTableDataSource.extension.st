Extension { #name : 'SpMorphicTreeTableDataSource' }

{ #category : '*NewTools-Scopes-Editor' }
SpMorphicTreeTableDataSource >> togglePath: aPath [
	(self itemAtPath: aPath) ifNotNil:[ :aNode | 
		aNode toggle.
		self tableRefresh ]
]
