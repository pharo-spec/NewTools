Class {
	#name : 'StComposedMessageBrowser',
	#superclass : 'StMessageBrowser',
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'initialization' }
StComposedMessageBrowser >> newMessageList [

	^ self instantiate: StComposedMessageListPresenter
]
