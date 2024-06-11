Extension { #name : 'RBOrEnvironment' }

{ #category : '*NewTools-Scopes' }
RBOrEnvironment >> fullPackages [
	" full packages are packages explicitely defined in the scope. i.e. there is a RBPackageEnvironment defining them "

	| fullPackages |
	fullPackages := Set new.
	fullPackages addAll: environment fullPackages.
	fullPackages addAll: otherEnvironment fullPackages.
	^ fullPackages
]

{ #category : '*NewTools-Scopes' }
RBOrEnvironment >> rawOrphanClasses [

	| orphanClasses |
	orphanClasses := Set new.
	orphanClasses addAll: environment orphanClasses.
	orphanClasses addAll: otherEnvironment orphanClasses.
	^ orphanClasses
]
