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

{ #category : 'executing' }
StRemoveMethodCommand >> execute [
	
	context doRemoveMethod
]
