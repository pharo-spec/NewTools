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

	| browser |
	[
		browser := StMethodBrowser browseReferencesToClass: StMethodBrowserDummyClass.

		self assert: browser methods size equals: 6] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testBrowseClassNameAsLiteral [

	| browser |
	[
		browser := StMethodBrowser browseReferencesToLiteral: 'StMethodBrowser'.

		self assert: browser methods size equals: 4 ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testBrowseReferencesToVariableInClass [

	| browser | 
	[
		browser := StMethodBrowser browseReferencesToVariable: (StMethodBrowser slotNamed: #title )inClass: StMethodBrowser.

		self assert: browser methods size equals: 2 ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testCallerClassIsSetFromConstructor [

	| browser |
	[
		browser := StMethodBrowser browseImplementorsOf: #printOn: from: self class.


		self assert: browser callerClass isNotNil.
		self assert: browser callerClass identicalTo: self class ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testDeprecatedMethodDisplayedStruckOut [

	| browser deprecatedMethod label column |
	[
		self class
			compile: 'tmpDeprecatedMethod
            self deprecated: ''Use something else''.
            ^ self'
			classified: 'tests-protocol'.
		deprecatedMethod := self class >> #tmpDeprecatedMethod.

		browser := StMethodBrowser browseImplementorsOf: #tmpDeprecatedMethod.
		column := browser methodList listPresenter contentView columns detect: [ :col | col title = 'Selector' ].
		label := SpLabelPresenter new.
		column bindAction value: label value: deprecatedMethod.


		self assert: (label displayStrikethrough cull: deprecatedMethod) ] ensure: [
			self class removeSelector: #tmpDeprecatedMethod.
			browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testExplicitBrowseClassNameAsClass [

	| browser |
	[
		browser := StMethodBrowser
			          browse: {
					          (StMethodBrowserTest >> #testBrowseClassNameAsClass).
					          (StMethodBrowserTest >> #testExplicitBrowseClassNameAsClass) }
			          asReferencesToClass: StMethodBrowserDummyClass.

		self assert: browser methods size equals: 2 ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testExplicitBrowseClassNameAsLiteral [

	| browser |
	[
		browser := StMethodBrowser
			           browse: {
					           (StMethodBrowserTest >> #dataMethodForTest).
					           (StMethodBrowserTest >> #testExplicitBrowseClassNameAsLiteral) }
			           asReferencesToLiteral: 'StMethodBrowser'.

		self assert: browser methods size equals: 2 ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testExplicitBrowseImplementors [

	| browser |
	[
		browser := StMethodBrowser
			           browse: { (StMethodBrowser >> #methods:asImplementorsOfAll:) }
			           asImplementorsOf: #methods:asImplementorsOfAll:.
		self assert: browser methods size equals: 1 ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testExplicitBrowseSenders [

	| browser |
	[
		browser := StMethodBrowser browse: { (StMethodBrowserTest >> #testMethodBrowserSenders) } asSendersOf: #browseImplementorsOf:.
		self assert: browser methods size equals: 1 ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodAddedAddsMatchingSender [

	| browser initialSize newMethod |
	[
		browser := StMethodBrowser browseSendersOf: #printOn:.
		initialSize := browser methods size.

		self class compile: 'tmpSenderMethodForTest ^ self printOn: String new' classified: 'tests-protocol'.
		newMethod := self class >> #tmpSenderMethodForTest.

		browser handleMethodAdded: (MethodAdded method: newMethod).

		self assert: browser methods size equals: initialSize + 1.
		self assert: (browser methods includes: newMethod) ] ensure: [
			self class removeSelector: #tmpSenderMethodForTest.
			browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodAddedWithActiveFilterKeepsUnfilteredItems [

	| browser total newMethod |
	[
		browser := StMethodBrowser browseSendersOf: #printOn:.
		total := browser filterPresenter unfilteredItems size.
		self assert: total > 0.
		browser filterPresenter filterInputPresenter text: 'zzznomatch'.
		self assert: browser methodList numberOfElements equals: 0.
		self class compile: 'tmpSenderMethodForTest ^ self printOn: String new' classified: 'tests-protocol'.
		newMethod := self class >> #tmpSenderMethodForTest.
		browser handleMethodAdded: (MethodAdded method: newMethod).

		self assert: browser filterPresenter unfilteredItems size > total ] ensure: [
			self class removeSelector: #tmpSenderMethodForTest.
			browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodModifiedPreservesOrder [

	| browser method initialOrder indexBefore |
	[
		self class compile: 'methodForTest ^ Object new printOn: Transcript' classified: 'tests-protocol'.
		method := self class >> #methodForTest.

		browser := StMethodBrowser browseSendersOf: #printOn:.
		initialOrder := browser methods copy.
		indexBefore := initialOrder indexOf: method.
		self assert: indexBefore > 0.

		self class compile: 'methodForTest ^ Object new printOn: Transcript "modified"' classified: 'tests-protocol'.
		browser handleMethodModified:
			(MethodModified methodChangedFrom: method to: self class >> #methodForTest oldProtocol: method protocol).
		self assert: (browser methods indexOf: self class >> #methodForTest) equals: indexBefore ] ensure: [
			self class removeSelector: #methodForTest.
			browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodModifiedPreservesScopeSelection [
	"After a method is modified, the selected scope should remain the same"

	| browser method |
	[
		self class compile: 'methodForTest ^ Object new printOn: Transcript' classified: 'tests-protocol'.
		method := self class >> #methodForTest.

		browser := StMethodBrowser browseSendersOf: #printOn:.
		browser selectIndex: 1.

		browser toolbarPresenter scopeList selectIndex: 3.

		self class compile: 'methodForTest ^ Object new printOn: Transcript "modified"' classified: 'tests-protocol'.
		browser handleMethodModified:
			(MethodModified methodChangedFrom: method to: self class >> #methodForTest oldProtocol: method protocol).


		self assert: browser toolbarPresenter scopeList selectedIndex equals: 3 ] ensure: [
			self class removeSelector: #methodForTest.
			browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodModifiedRemovesSenderWhenNoLongerMatching [

	| browser method |
	[
		self class compile: 'methodForTest ^ Object new printOn: Transcript' classified: 'tests-protocol'.
		method := self class >> #methodForTest.

		browser := StMethodBrowser browseSendersOf: #printOn:.
		self assert: (browser methods includes: method).
		self class compile: 'methodForTest ^ Object new'.
		browser handleMethodModified:
			(MethodModified methodChangedFrom: method to: self class >> #methodForTest oldProtocol: method protocol).

		self deny: (browser methods includes: method) ] ensure: [
			self class removeSelector: #methodForTest.
			browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodRemovedRemovesMatchingMethod [

	| browser method announcement initialSize |
	[
		browser := StMethodBrowser browseImplementorsOf: #printOn:.
		method := browser methods anyOne.
		initialSize := browser methods size.

		announcement := MethodRemoved new method: method compiledMethod.

		browser handleMethodRemoved: announcement.

		self assert: browser methods size equals: initialSize - 1 ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHandleMethodRemovedUpdatesSelection [

	| browser method |
	[
		browser := StMethodBrowser browseImplementorsOf: #printOn:.


		method := browser methods third.
		browser methodList unselectAll.
		browser selectIndex: 3.

		browser handleMethodRemoved: (MethodRemoved new method: method compiledMethod).
		self currentWorld doOneCycle.
		self assert: (browser methods indexOf: browser selectedMethod) equals: 3 ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testHighlightSelectsFirstOccurrence [

	| browser interval |
	[
		browser := StMethodBrowser browseSendersOf: #printOn:.
		interval := browser codeEditor codePresenter selectionInterval.

		self assert: interval isNotEmpty.
		self assert: ((browser codeEditor text copyFrom: interval first to: interval last) includesSubstring: 'printOn:') ] ensure: [
		browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testMethodBrowserImplementors [

	| browser |
	[
		browser := StMethodBrowser browseImplementorsOf: #printOn:.
		browser methods size > 0 ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testMethodBrowserSenders [

	| browser |
	[
		browser := StMethodBrowser browseImplementorsOf: #browseImplementorsOf:.
		browser methods size > 0 ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testMethodsAreSortedByHierarchy [

	| browser methodObject methodCollection methodArray |
	methodObject := Object >> #printString.
	methodCollection := Collection >> #size.
	methodArray := Array >> #asArray.

	[
		browser := StMethodBrowser browse: {
				           methodArray.
				           methodObject.
				           methodCollection }.
		self assert: browser methods first compiledMethod equals: methodObject.
		self assert: browser methods second compiledMethod equals: methodCollection.
		self assert: browser methods third compiledMethod equals: methodArray ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests - smoke' }
StMethodBrowserTest >> testOpenWithoutMessageShouldNotDNU [

	| browser |
	[
		browser := StMethodBrowser new.
		self shouldnt: [ browser open ] raise: MessageNotUnderstood ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testRefreshingBlockWithLiteralString [

	| browser methodToAdd |
	[
		browser := StMethodBrowser browseReferencesToLiteral: 'StMethodBrowser'.

		methodToAdd := (self class >> #dataMethodForTest) copy.
		self assert: (browser acceptBlock value: methodToAdd) ] ensure: [ browser ifNotNil: [ browser delete ] ]
]

{ #category : 'tests' }
StMethodBrowserTest >> testSendersHidesRecursiveCallForMultipleSelectors [
	"If the only senders of a collection of selectors are recursive calls, no result should be shown"

	| browser selectorA selectorB |
	selectorA := #tmpRecursive , #A.
	selectorB := #tmpRecursive , #B.

	browser := StMethodBrowser new
		           callerClass: StMethodBrowserDummyClass;
		           yourself.
	browser methods: (StMethodBrowser sendersOf: selectorA) , (StMethodBrowser sendersOf: selectorB) asSendersOfAll: {
			selectorA.
			selectorB }.

	self assert: browser allMethods isEmpty
]

{ #category : 'tests' }
StMethodBrowserTest >> testSendersHidesRecursiveCallWhenOnlySender [
	"If the only sender of a method is itself, no result should be shown"

	| browser selectorName |
	selectorName := #tmpRecursive , #Method.

	browser := StMethodBrowser new
		           callerClass: StMethodBrowserDummyClass;
		           yourself.
	browser methods: (StMethodBrowser sendersOf: selectorName) asSendersOfAll: { selectorName }.

	self assert: browser allMethods isEmpty
]

{ #category : 'tests' }
StMethodBrowserTest >> testSendersKeepsRecursiveCallWhenOtherSendersExist [
	"If a method has other senders besides itself, keep all including the recursive call"

	| browser selectorName |
	selectorName := #tmpRecursive , #Method2.
	browser := StMethodBrowser new
		           callerClass: StMethodBrowserDummyClass;
		           yourself.
	browser methods: (StMethodBrowser sendersOf: selectorName) asSendersOfAll: { selectorName }.

	self assert: browser allMethods size equals: 2.
	self assert: (browser allMethods anySatisfy: [ :m | m selector = selectorName ]).
	self assert: (browser allMethods anySatisfy: [ :m | m selector = #tmpOtherCaller ])
]

{ #category : 'tests' }
StMethodBrowserTest >> testSendersOfExcludesTraitUsers [

	| senders |
	senders := StMethodBrowser sendersOf: #sendMe.

	self assert: (senders anySatisfy: [ :m | m methodClass = TData ]).
	self deny: (senders anySatisfy: [ :m | m methodClass = StMethodBrowserDummyClass ])
]

{ #category : 'tests' }
StMethodBrowserTest >> testWindowTitleWithFilterRatio [

	| browser total filtered |
	[
		browser := StMethodBrowser browseSendersOf: #printOn:.


		total := browser methods size.

		browser filterPresenter filterInputPresenter text: 'print'.
		filtered := browser methodList numberOfElements.

		self assert: filtered < total.
		self assert: (browser windowTitle includesSubstring: filtered asString , '/' , total asString) ] ensure: [
		browser ifNotNil: [ browser delete ] ]
]
