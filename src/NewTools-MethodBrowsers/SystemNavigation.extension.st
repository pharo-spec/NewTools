Extension { #name : 'SystemNavigation' }

{ #category : '*NewTools-MethodBrowsers' }
SystemNavigation >> browseAllUsersOfClassOrTrait: class [

	class isTrait 
		ifTrue: [ self browseAllUsersOfTrait: class ]
		ifFalse: [ self browseAllCallsOnClass: class ]
]

{ #category : '*NewTools-MethodBrowsers' }
SystemNavigation >> browseVersionsOf: aMethod [

	self tools versionBrowser browseVersionsForMethod: aMethod
]
