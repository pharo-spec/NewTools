"
Remove selected method from a message browser list
"
Class {
	#name : 'StRemoveMethodsCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StRemoveMethodsCommand class >> defaultName [

	^ '(R) Remove'
]

{ #category : 'accessing' }
StRemoveMethodsCommand class >> defaultShortcut [

	^ $x actionModifier
]

{ #category : 'testing' }
StRemoveMethodsCommand >> canBeExecuted [

	^ context selectedMethod isNotNil
]

{ #category : 'executing' }
StRemoveMethodsCommand >> execute [

	(ReRemoveMethodDriver new scopes: context owner allScopes methods: context selectedMethods) runRefactoring
]
