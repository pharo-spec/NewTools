Extension { #name : 'SpMorphicTreeTableDataSource' }

{ #category : '*NewTools-ScopesBrowser' }
SpMorphicTreeTableDataSource >> togglePath: aPath [
	(self itemAtPath: aPath) ifNotNil:[ :aNode | 
		aNode toggle.
		self tableRefresh ]
]
