Extension { #name : 'RBBrowserEnvironment' }

{ #category : '*NewTools-Scopes' }
RBBrowserEnvironment >> fullPackages [
	^ self packages
]

{ #category : '*NewTools-Scopes' }
RBBrowserEnvironment >> isPackageEnvironment [
	
	^ false
]

{ #category : '*NewTools-Scopes' }
RBBrowserEnvironment >> orphanClasses [
	^ #()
]
