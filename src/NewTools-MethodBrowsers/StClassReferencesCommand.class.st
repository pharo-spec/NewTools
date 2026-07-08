"
Browse references to class containing method from a message browser list
"
Class {
	#name : 'StClassReferencesCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'default' }
StClassReferencesCommand class >> defaultDescription [

	^ 'Browse all methods using the selector of the current method'
]

{ #category : 'accessing' }
StClassReferencesCommand class >> defaultName [

	^ 'References'
]

{ #category : 'accessing' }
StClassReferencesCommand class >> defaultShortcut [

	^ $n shift actionModifier
]

{ #category : 'executing' }
StClassReferencesCommand >> execute [
	
	context doBrowseUsers
]
