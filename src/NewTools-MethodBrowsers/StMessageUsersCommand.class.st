"
Browse references to class containing method from a message browser list
"
Class {
	#name : 'StMessageUsersCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'default' }
StMessageUsersCommand class >> defaultDescription [

	^ 'Browse all methods using the selector of the current method'
]

{ #category : 'accessing' }
StMessageUsersCommand class >> defaultName [

	^ 'References'
]

{ #category : 'accessing' }
StMessageUsersCommand class >> defaultShortcut [

	^ $n shift actionModifier
]

{ #category : 'executing' }
StMessageUsersCommand >> execute [
	
	context doBrowseUsers
]
