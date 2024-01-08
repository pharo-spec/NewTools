"
Browse full method from a message browser list
"
Class {
	#name : 'StMessageBrowseFullCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StMessageBrowseFullCommand class >> defaultName [

	^ 'Browse full'
]

{ #category : 'accessing' }
StMessageBrowseFullCommand class >> defaultShortcut [

	^ $b actionModifier
]

{ #category : 'executing' }
StMessageBrowseFullCommand >> execute [
	
	context doBrowseMethod
]
