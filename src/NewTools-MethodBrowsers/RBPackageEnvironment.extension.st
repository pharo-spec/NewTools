Extension { #name : 'RBPackageEnvironment' }

{ #category : '*NewTools-MethodBrowsers' }
RBPackageEnvironment >> selectMessagesFrom: aCollection [ 
	"Answer a <Collection> of <CompiledMethod> present in the receiver"

	^ self packages flatCollect: [ : pck | 
		aCollection select: [ : mth | 
			pck
				includesSelector: mth selector 
				ofClass: mth methodClass ] ].
]
