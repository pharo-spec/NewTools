"
Browse implementors from a message browser list
"
Class {
	#name : 'StImplementorsCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'default' }
StImplementorsCommand class >> defaultDescription [

	^ 'Browse all methods implementing the selector of the current method'
]

{ #category : 'accessing' }
StImplementorsCommand class >> defaultName [

	^ 'Implementors'
]

{ #category : 'accessing' }
StImplementorsCommand class >> defaultShortcut [

	^ $m actionModifier
]

{ #category : 'executing' }
StImplementorsCommand >> execute [
	
	context doBrowseImplementors
]
