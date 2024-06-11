"
Browse method versions from a message browser list
"
Class {
	#name : 'StMessageVersionsCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StMessageVersionsCommand class >> defaultName [

	^ 'Versions'
]

{ #category : 'accessing' }
StMessageVersionsCommand class >> defaultShortcut [

	^ $v actionModifier
]

{ #category : 'executing' }
StMessageVersionsCommand >> execute [
	
	context doBrowseVersions
]
