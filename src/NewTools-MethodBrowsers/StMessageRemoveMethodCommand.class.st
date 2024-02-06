"
Remove selected method from a message browser list
"
Class {
	#name : 'StMessageRemoveMethodCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StMessageRemoveMethodCommand class >> defaultName [

	^ 'Remove method'
]

{ #category : 'accessing' }
StMessageRemoveMethodCommand class >> defaultShortcut [

	^ $x actionModifier
]

{ #category : 'executing' }
StMessageRemoveMethodCommand >> execute [
	
	context doRemoveMethod
]
