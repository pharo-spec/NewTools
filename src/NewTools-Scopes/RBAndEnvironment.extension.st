Extension { #name : 'RBAndEnvironment' }

{ #category : '*NewTools-Scopes' }
RBAndEnvironment >> fullPackages [
	" full packages are packages explicitely defined in the scope. i.e. there is a RBPackageEnvironment defining them "

	| fullPackages |
	fullPackages := Set new.
	fullPackages addAll: environment fullPackages.
	fullPackages intersection: otherEnvironment fullPackages.
	^ fullPackages
]

{ #category : '*NewTools-Scopes' }
RBAndEnvironment >> rawOrphanClasses [
	| orphanClasses |
	orphanClasses := Set new.
	orphanClasses addAll: environment orphanClasses.
	orphanClasses intersection: otherEnvironment orphanClasses.
	^ orphanClasses
]
