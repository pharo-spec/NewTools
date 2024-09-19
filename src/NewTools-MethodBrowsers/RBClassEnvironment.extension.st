Extension { #name : 'RBClassEnvironment' }

{ #category : '*NewTools-MethodBrowsers' }
RBClassEnvironment >> selectMessagesFrom: aCollection [ 
	"Answer a <Collection> of <CompiledMethod> present in the receiver"

	self halt.
	^ self classes flatCollect: [ : cls | 
		aCollection select: [ : item | cls = item  ] ].
]
