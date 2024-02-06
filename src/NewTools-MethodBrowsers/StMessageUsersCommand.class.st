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
