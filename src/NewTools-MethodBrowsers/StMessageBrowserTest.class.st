Class {
	#name : 'StMessageBrowserTest',
	#superclass : 'TestCase',
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'tests' }
StMessageBrowserTest >> testOpenWithoutMessageShouldNotDNU [

	| br |
	[ br := StMessageBrowser new.
	self shouldnt: [ br open ] raise: MessageNotUnderstood.
	] ensure: [ br window close ]

	
]
