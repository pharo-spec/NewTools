Extension { #name : 'SpMorphicTreeTableDataSource' }

{ #category : '*NewTools-Scopes-Browser' }
SpMorphicTreeTableDataSource >> togglePath: aPath [
	(self itemAtPath: aPath) ifNotNil:[ :aNode | 
		aNode toggle.
		self tableRefresh ]
]
