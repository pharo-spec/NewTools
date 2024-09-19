Extension { #name : 'RBClassHierarchyEnvironment' }

{ #category : '*NewTools-MethodBrowsers' }
RBClassHierarchyEnvironment >> selectMessagesFrom: aCollectionOfCompiledMethod [ 
	"Since the receiver is a system environment, answer all messages in aCollection"	

	^ (aCollectionOfCompiledMethod 
		reject: [ : cm | cm methodClass isMeta ]) "see https://github.com/pharo-project/pharo/issues/17139"
			select: [ : cm | cm methodClass isInClassHierarchyOf: class ]
]
