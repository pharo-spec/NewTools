"
Browse implementors from a message browser list
"
Class {
	#name : 'StMessageImplementorsCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StMessageImplementorsCommand class >> defaultName [

	^ 'Implementors'
]

{ #category : 'accessing' }
StMessageImplementorsCommand class >> defaultShortcut [

	^ $m actionModifier
]

{ #category : 'executing' }
StMessageImplementorsCommand >> execute [
	
	context doBrowseImplementors
]
