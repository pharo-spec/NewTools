"
Remove selected method from a message browser list
"
Class {
	#name : 'StRemoveMethodCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StRemoveMethodCommand class >> defaultName [

	^ 'Remove method'
]

{ #category : 'accessing' }
StRemoveMethodCommand class >> defaultShortcut [

	^ $x actionModifier
]

{ #category : 'testing' }
StRemoveMethodCommand >> canBeExecuted [

	^ context selectedMethod isNotNil
]

{ #category : 'executing' }
StRemoveMethodCommand >> execute [
	
	(ReRemoveMethodDriver new
				 scopes: context owner allScopes
				 methods: {context selectedMethod}) runRefactoring
]
