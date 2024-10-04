Extension { #name : 'RBClassEnvironment' }

{ #category : '*NewTools-MethodBrowsers' }
RBClassEnvironment >> selectMessagesFrom: aCollectionOfCompiledMethod [ 
	"Filter methods in aCollectionOfCompiledMethod for which their method class is present in the receiver's classes
	 Answer a <Collection> of <CompiledMethod>"

	^ self classes flatCollect: [ : cls | 
		aCollectionOfCompiledMethod select: [ : cm | cls = cm methodClass  ] ].
]
