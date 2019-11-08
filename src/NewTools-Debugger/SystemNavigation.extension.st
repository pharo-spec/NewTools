Extension { #name : #SystemNavigation }

{ #category : #'*NewTools-Debugger' }
SystemNavigation >> allHalts [

	^ self allBehaviors
		flatCollect:
			[ :class | class methods select: [ :method | method hasHalts ] ]
]
