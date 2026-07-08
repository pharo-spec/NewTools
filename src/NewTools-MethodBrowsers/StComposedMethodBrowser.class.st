Class {
	#name : 'StComposedMethodBrowser',
	#superclass : 'StMethodBrowser',
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'initialization' }
StComposedMethodBrowser >> newMethodList [

	^ self instantiate: StComposedMethodListPresenter
]
