Extension { #name : 'SpTreeTablePresenter' }

{ #category : '*NewTools-ScopesBrowser' }
SpTreeTablePresenter >> collapseSelectedItems [
	self selection selectedPaths do: [ :path | self collapsePath: path ]
]

{ #category : '*NewTools-ScopesBrowser' }
SpTreeTablePresenter >> expandSelectedItems [
	self selection selectedPaths do: [ :path | self expandPath: path ]
]

{ #category : '*NewTools-ScopesBrowser' }
SpTreeTablePresenter >> togglePath: aPath [
	self withAdapterPerformOrDefer: [ :anAdapter |
		anAdapter togglePath: aPath ]
]

{ #category : '*NewTools-ScopesBrowser' }
SpTreeTablePresenter >> toggleSelectedItems [
	self selection selectedPaths do: [ :path | self togglePath: path ]
]
