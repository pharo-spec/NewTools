Extension { #name : 'RBBrowserEnvironment' }

{ #category : '*NewTools-MethodBrowsers' }
RBBrowserEnvironment >> selectMessagesFrom: aCollectionOfCompiledMethod [ 
	"Since the receiver is a system environment, answer all messages in aCollection"	

	^ aCollectionOfCompiledMethod 
]
