Extension { #name : 'Package' }

{ #category : '*NewTools-DependencyAnalyser' }
Package >> manuallyResolvedDependencies [

	^ self packageManifestOrNil
		ifNil: [ #() ]
		ifNotNil: #manuallyResolvedDependencies
]
