Trait {
	#name : 'TData',
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Tests'
}

{ #category : 'accessing' }
TData >> sendMe [

	^ 2
]

{ #category : 'accessing' }
TData >> sender [

	self sendMe
]
