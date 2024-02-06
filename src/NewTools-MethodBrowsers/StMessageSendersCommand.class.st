"
Browse senders of selected method from a message browser list
"
Class {
	#name : 'StMessageSendersCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StMessageSendersCommand class >> defaultName [

	^ 'Senders'
]

{ #category : 'accessing' }
StMessageSendersCommand class >> defaultShortcut [

	^ $n actionModifier
]

{ #category : 'executing' }
StMessageSendersCommand >> execute [
	
	context doBrowseSenders
]
