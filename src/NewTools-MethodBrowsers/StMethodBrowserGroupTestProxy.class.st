"
Test double for StMethodBrowserGroup whose application is swapped in to stub the discard-changes confirmation dialog.
"
Class {
	#name : 'StMethodBrowserGroupTestProxy',
	#superclass : 'Object',
	#instVars : [
		'wrapped',
		'confirmAnswer'
	],
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Tests'
}

{ #category : 'confirming' }
StMethodBrowserGroupTestProxy >> confirm: aMessage [

	^ confirmAnswer
]

{ #category : 'accessing' }
StMethodBrowserGroupTestProxy >> confirmAnswer: aBoolean [

	confirmAnswer := aBoolean
]

{ #category : 'forwarding' }
StMethodBrowserGroupTestProxy >> doesNotUnderstand: aMessage [

	^ wrapped perform: aMessage selector withArguments: aMessage arguments
]

{ #category : 'accessing' }
StMethodBrowserGroupTestProxy >> hasConfirmed [

	^ confirmAnswer
]

{ #category : 'accessing' }
StMethodBrowserGroupTestProxy >> wrapped: anObject [

	wrapped := anObject
]
