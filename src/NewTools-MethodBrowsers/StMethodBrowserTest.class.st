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

		self assert: window presenter methods size equals: 4 ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testBrowseReferencesToVariableInClass [

	| window | 
	[
		window := StMethodBrowser browseReferencesToVariable: (StMethodBrowser slotNamed: #title )inClass: StMethodBrowser.

		self assert: window presenter methods size equals: 2 ] ensure: [ window ifNotNil: [ window delete ] ]
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

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodRemovedRemovesMatchingMethod [

	| window browser method announcement initialSize |
	[
		window := StMethodBrowser browseImplementorsOf: #printOn:.
		browser := window presenter.

		method := browser methods anyOne.
		initialSize := browser methods size.

		announcement := MethodRemoved new method: method compiledMethod.

		browser handleMethodRemoved: announcement.

		self assert: browser methods size equals: initialSize - 1 ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodRemovedUpdatesSelection [

	| window browser method |
	[
		window := StMethodBrowser browseImplementorsOf: #printOn:.
		browser := window presenter.

		method := browser methods second.
		browser selectIndex: 2.

		browser handleMethodRemoved: (MethodRemoved new method: method compiledMethod).
		World doOneCycle.
		self assert: (browser methods indexOf: browser selectedMethod) equals: 2 ] ensure: [ window ifNotNil: [ window delete ] ]
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

{ #category : 'tests' }
StMethodBrowserTest >> testRefreshingBlockWithLiteralString [

	| window browser methodToAdd |
	[
		window := StMethodBrowser browseReferencesToLiteral: 'StMethodBrowser'.
		browser := window presenter.
		methodToAdd := (self class >> #dataMethodForTest) copy.
		self assert: (browser refreshingBlock value: methodToAdd) ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testWindowTitleWithFilterRatio [

	| window browser total filtered |
	[
		window := StMethodBrowser browseSendersOf: #printOn:.
		browser := window presenter.

		total := browser methods size.

		browser filterPresenter filterInputPresenter text: 'print'.
		filtered := browser methodList numberOfElements.

		filtered < total ifTrue: [ self assert: (browser windowTitle includesSubstring: '/') ] ] ensure: [
		window ifNotNil: [ window delete ] ]
]
