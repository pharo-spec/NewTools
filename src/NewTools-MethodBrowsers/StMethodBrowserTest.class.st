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

		self assert: window presenter methods size equals: 3] ensure: [ window ifNotNil: [ window delete ] ]
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
StMethodBrowserTest >> testCallerClassIsSetFromConstructor [

	| window browser |
	[
		window := StMethodBrowser browseImplementorsOf: #printOn: from: self class.
		browser := window presenter.

		self assert: browser callerClass isNotNil.
		self assert: browser callerClass identicalTo: self class ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testDeprecatedMethodDisplayedStruckOut [

	| window browser deprecatedMethod label column |
	[
		self class
			compile: 'tmpDeprecatedMethod
            self deprecated: ''Use something else''.
            ^ self'
			classified: 'tests-protocol'.
		deprecatedMethod := self class >> #tmpDeprecatedMethod.

		window := StMethodBrowser browseImplementorsOf: #tmpDeprecatedMethod.
		browser := window presenter.
		column := browser methodList listPresenter contentView columns detect: [ :col | col title = 'Selector' ].
		label := SpLabelPresenter new.
		column bindAction value: label value: deprecatedMethod.


		self assert: (label displayStrikethrough cull: deprecatedMethod) ] ensure: [
			self class removeSelector: #tmpDeprecatedMethod.
			window ifNotNil: [ window delete ] ]
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
StMethodBrowserTest >> testExplicitBrowseImplementors [

	| window |
	[
		window := StMethodBrowser
			          browse: { (StMethodBrowser >> #methods:asImplementorsOfAll:) }
			          asImplementorsOf: #methods:asImplementorsOfAll:.
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
StMethodBrowserTest >> testHandleMethodAddedAddsMatchingSender [

	| window browser initialSize newMethod |
	[
		window := StMethodBrowser browseSendersOf: #printOn:.
		browser := window presenter.
		initialSize := browser methods size.

		self class compile: 'tmpSenderMethodForTest ^ self printOn: String new' classified: 'tests-protocol'.
		newMethod := self class >> #tmpSenderMethodForTest.

		browser handleMethodAdded: (MethodAdded method: newMethod).

		self assert: browser methods size equals: initialSize + 1.
		self assert: (browser methods includes: newMethod) ] ensure: [
			self class removeSelector: #tmpSenderMethodForTest.
			window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodAddedWithActiveFilterKeepsUnfilteredItems [

	| window browser total newMethod |
	[
		window := StMethodBrowser browseSendersOf: #printOn:.
		browser := window presenter.
		total := browser filterPresenter unfilteredItems size.
		self assert: total > 0.
		browser filterPresenter filterInputPresenter text: 'zzznomatch'.
		self assert: browser methodList numberOfElements equals: 0.
		self class compile: 'tmpSenderMethodForTest ^ self printOn: String new' classified: 'tests-protocol'.
		newMethod := self class >> #tmpSenderMethodForTest.
		browser handleMethodAdded: (MethodAdded method: newMethod).

		self assert: browser filterPresenter unfilteredItems size > total ] ensure: [
			self class removeSelector: #tmpSenderMethodForTest.
			window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodModifiedPreservesOrder [

	| window browser method initialOrder indexBefore |
	[
		self class compile: 'methodForTest ^ Object new printOn: Transcript' classified: 'tests-protocol'.
		method := self class >> #methodForTest.

		window := StMethodBrowser browseSendersOf: #printOn:.
		browser := window presenter.
		initialOrder := browser methods copy.
		indexBefore := initialOrder indexOf: method.
		self assert: indexBefore > 0.

		self class compile: 'methodForTest ^ Object new printOn: Transcript "modified"' classified: 'tests-protocol'.
		browser handleMethodModified:
			(MethodModified methodChangedFrom: method to: self class >> #methodForTest oldProtocol: method protocol).
		self assert: (browser methods indexOf: self class >> #methodForTest) equals: indexBefore ] ensure: [
			self class removeSelector: #methodForTest.
			window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodModifiedPreservesScopeSelection [
	"After a method is modified, the selected scope should remain the same"

	| window browser method |
	[
		self class compile: 'methodForTest ^ Object new printOn: Transcript' classified: 'tests-protocol'.
		method := self class >> #methodForTest.

		window := StMethodBrowser browseSendersOf: #printOn:.
		browser := window presenter.
		browser selectIndex: 1.

		browser toolbarPresenter scopeList selectIndex: 3.

		self class compile: 'methodForTest ^ Object new printOn: Transcript "modified"' classified: 'tests-protocol'.
		browser handleMethodModified:
			(MethodModified methodChangedFrom: method to: self class >> #methodForTest oldProtocol: method protocol).


		self assert: browser toolbarPresenter scopeList selectedIndex equals: 3 ] ensure: [
			self class removeSelector: #methodForTest.
			window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodModifiedRemovesSenderWhenNoLongerMatching [

	| window browser method |
	[
		self class compile: 'methodForTest ^ Object new printOn: Transcript' classified: 'tests-protocol'.
		method := self class >> #methodForTest.

		window := StMethodBrowser browseSendersOf: #printOn:.
		browser := window presenter.
		self assert: (browser methods includes: method).
		self class compile: 'methodForTest ^ Object new'.
		browser handleMethodModified:
			(MethodModified methodChangedFrom: method to: self class >> #methodForTest oldProtocol: method protocol).

		self deny: (browser methods includes: method) ] ensure: [
			self class removeSelector: #methodForTest.
			window ifNotNil: [ window delete ] ]
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

		method := browser methods third.
		browser methodList unselectAll.
		browser selectIndex: 3.

		browser handleMethodRemoved: (MethodRemoved new method: method compiledMethod).
		self currentWorld doOneCycle.
		self assert: (browser methods indexOf: browser selectedMethod) equals: 3 ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHighlightSelectsFirstOccurrence [

	| window browser interval |
	[
		window := StMethodBrowser browseSendersOf: #printOn:.
		browser := window presenter.
		interval := browser codeEditor codePresenter selectionInterval.

		self assert: interval isNotEmpty.
		self assert: ((browser codeEditor text copyFrom: interval first to: interval last) includesSubstring: 'printOn:') ] ensure: [
		window ifNotNil: [ window delete ] ]
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

{ #category : 'tests' }
StMethodBrowserTest >> testMethodsAreSortedByHierarchy [

	| window browser methodObject methodCollection methodArray |
	methodObject := Object >> #printString.
	methodCollection := Collection >> #size.
	methodArray := Array >> #asArray.

	[
		window := StMethodBrowser browse: {
				          methodArray.
				          methodObject.
				          methodCollection }.
		browser := window presenter.

		self assert: browser methods first compiledMethod equals: methodObject.
		self assert: browser methods second compiledMethod equals: methodCollection.
		self assert: browser methods third compiledMethod equals: methodArray ] ensure: [ window ifNotNil: [ window delete ] ]
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testOpenWithoutMessageShouldNotDNU [

	| br |
	br := StMethodBrowser new.
	self shouldnt: [ br open ] raise: MessageNotUnderstood
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
StMethodBrowserTest >> testReuseWindowCheckboxInitialState [

	| presenter initialSetting |
	initialSetting := StMethodBrowser navigateInPlace.
	[
		StMethodBrowser navigateInPlace: true.
		presenter := StMethodBrowser new.
		self assert: presenter toolbarPresenter reuseWindowButton state.
		StMethodBrowser navigateInPlace: false.
		presenter := StMethodBrowser new.
		self deny: presenter toolbarPresenter reuseWindowButton state ] ensure: [
			StMethodBrowser navigateInPlace: initialSetting.
			presenter ifNotNil: [ presenter delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testSendersHidesRecursiveCallWhenOnlySender [
	"If the only sender of a method is itself, no result should be shown"

	| browser senders |
	[
		self class compile: 'tmpRecursiveMethod ^ self tmpRecursiveMethod' classified: 'tests-protocol'.

		senders := (StMethodBrowser sendersOf: #tmpRecursiveMethod) reject: [ :m | m methodClass = self class ].

		browser := StMethodBrowser new
			           callerClass: self class;
			           yourself.
		browser methods: senders asSendersOfAll: { #tmpRecursiveMethod }.

		self assert: browser allMethods isEmpty ] ensure: [ self class removeSelector: #tmpRecursiveMethod ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testSendersKeepsRecursiveCallWhenOtherSendersExist [
	"If a method has other senders besides itself, keep all including the recursive call"

	| browser senders |
	[
		self class compile: 'tmpRecursiveMethod2 ^ self tmpRecursiveMethod2' classified: 'tests-protocol'.
		self class compile: 'tmpOtherCaller ^ self tmpRecursiveMethod2' classified: 'tests-protocol'.

		senders := (StMethodBrowser sendersOf: #tmpRecursiveMethod2) reject: [ :m |
			           m methodClass = self class and: [ m selector ~= #tmpRecursiveMethod2 and: [ m selector ~= #tmpOtherCaller ] ] ].

		browser := StMethodBrowser new
			           callerClass: self class;
			           yourself.
		browser methods: senders asSendersOfAll: { #tmpRecursiveMethod2 }.

		self assert: browser allMethods size equals: 2.
		self assert: (browser allMethods anySatisfy: [ :m | m selector = #tmpRecursiveMethod2 ]).
		self assert: (browser allMethods anySatisfy: [ :m | m selector = #tmpOtherCaller ]) ] ensure: [
			self class removeSelector: #tmpRecursiveMethod2.
			self class removeSelector: #tmpOtherCaller ]
]

StMethodBrowserTest >> testSendersOfExcludesTraitUsers [

	| senders |
	senders := StMethodBrowser sendersOf: #sendMe.

	self assert: (senders anySatisfy: [ :m | m methodClass = TData ]).
	self deny: (senders anySatisfy: [ :m | m methodClass = StMethodBrowserData ])
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

		self assert: filtered < total.
		self assert: (browser windowTitle includesSubstring: filtered asString , '/' , total asString) ] ensure: [
		window ifNotNil: [ window delete ] ]
]
