"
Browse method versions from a message browser list
"
Class {
	#name : 'StMethodVersionsCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StMethodVersionsCommand class >> defaultName [

	^ 'Versions'
]

{ #category : 'accessing' }
StMethodVersionsCommand class >> defaultShortcut [

	^ $v actionModifier
]

{ #category : 'executing' }
StMethodVersionsCommand >> execute [
	
	context doBrowseVersions
]
