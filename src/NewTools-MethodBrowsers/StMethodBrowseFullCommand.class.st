"
Browse full method from a message browser list
"
Class {
	#name : 'StMethodBrowseFullCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StMethodBrowseFullCommand class >> defaultName [

	^ 'Browse full'
]

{ #category : 'accessing' }
StMethodBrowseFullCommand class >> defaultShortcut [

	^ $b actionModifier
]

{ #category : 'executing' }
StMethodBrowseFullCommand >> execute [
	
	context doBrowseMethod
]
