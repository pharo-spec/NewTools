Class {
	#name : 'StMethodBrowserTest',
	#superclass : 'TestCase',
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Tests'
}

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testMethodBrowserClassReference [
	
	| window |
	[
	window := StMethodBrowser browseReferencesOf: 'Point' ] 
		ensure: [ window delete ]
	
]

{ #category : 'tests' }
StMethodBrowserTest >> testMethodBrowserClassReferenceHasMethods [
	
	| window |
	[
	window := StMethodBrowser browseReferencesOf: 'Point'.
	self assert: window presenter methods size > 0 ] 
		ensure: [ window delete ]
	
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testMethodBrowserImplementors [
	
	| window |
	[
	window := StMethodBrowser browseImplementorsOf: #printOn: ] 
		ensure: [ window delete ]
	
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testMethodBrowserSenders [
	
	| window |
	[
	window := StMethodBrowser browseSendersOf: #printOn: ] 
		ensure: [ window delete ]
	
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testOpenWithoutMessageShouldNotDNU [

	| br |
	[ br := StMethodBrowser new.
	self shouldnt: [ br open ] raise: MessageNotUnderstood.
		] ensure: [ br window close ]
]
