Class {
	#name : 'StMethodBrowserTest',
	#superclass : 'TestCase',
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Tests'
}

{ #category : 'tests' }
StMethodBrowserTest >> dataMethodForTest [

	^ 'StMethodBrowser'
]

{ #category : 'tests' }
StMethodBrowserTest >> testBrowseClassNameAsClass [

	| window |
	[
		window := StMethodBrowser browseReferencesToClass: StMethodBrowserData.

		self assert: window presenter methods size equals: 2] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testBrowseClassNameAsLiteral [

	| window |
	[
		window := StMethodBrowser browseReferencesToLiteral: 'StMethodBrowser'.

		self assert: window presenter methods size equals: 3 ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testExplicitBrowseClassNameAsClass [

	| window |
	[
		window := StMethodBrowser
			          browse: {
					          (StMethodBrowserTest >> #testBrowseClassNameAsClass).
					          (StMethodBrowserTest >> #testExplicitBrowseClassNameAsClass) }
			          asReferencesToClass: StMethodBrowserData.

		self assert: window presenter methods size equals: 2 ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testExplicitBrowseClassNameAsLiteral [

	| window |
	[
	window := StMethodBrowser 
		browse: { StMethodBrowserTest>>#dataMethodForTest . StMethodBrowserTest>>#testExplicitBrowseClassNameAsLiteral } 
		asReferencesToLiteral: 'StMethodBrowser'.

	self assert: window presenter methods size equals: 2  ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testExplicitBrowseCompiledMethods [

	| window |
	[
		window := StMethodBrowser
			          browse: { (StMethodBrowser >> #methods:asImplementorsOf:) }
			          asImplementorsOf: #methods:asImplementorsOf:.
		self assert: window presenter methods size > 0 ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testExplicitBrowseImplementors [

	| window |
	[
		window := StMethodBrowser
			          browse: { (StMethodBrowser >> #methods:asImplementorsOf:) }
			          asImplementorsOf: #methods:asImplementorsOf:.
		self assert: window presenter methods size equals: 1 ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testExplicitBrowseSenders [

	| window |
	[
		window := StMethodBrowser browse: { (StMethodBrowserTest >> #testMethodBrowserSenders) } asSendersOf: #browseImplementorsOf:.
		self assert: window presenter methods size equals: 1 ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testMethodBrowserImplementors [

	| window |
	[ window := StMethodBrowser browseImplementorsOf: #printOn:. 
	window presenter methods size > 0 ] 
		ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testMethodBrowserSenders [

	| window |
	[
	window := StMethodBrowser browseImplementorsOf: #browseImplementorsOf:.
	window presenter methods size > 0 ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testOpenWithoutMessageShouldNotDNU [

	| br |
	[ br := StMethodBrowser new.
	self shouldnt: [ br open ] raise: MessageNotUnderstood.
		] ensure: [ br window close ]
]
