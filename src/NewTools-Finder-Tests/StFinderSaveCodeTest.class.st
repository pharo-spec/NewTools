Class {
	#name : 'StFinderSaveCodeTest',
	#superclass : 'StFinderTest',
	#instVars : [
		'oldMethod'
	],
	#category : 'NewTools-Finder-Tests-Core',
	#package : 'NewTools-Finder-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
StFinderSaveCodeTest >> setUp [

	super setUp.

	oldMethod := StFinderMockC
	             >> #aBCSelectorSearchForRegexpStartWithCase
]

{ #category : 'running' }
StFinderSaveCodeTest >> tearDown [

	StFinderMockC methodDict at: oldMethod selector put: oldMethod.

	(StFinderMockC includesSelector: #toto) ifTrue: [
		StFinderMockC removeSelector: #toto ].

	super tearDown
]

{ #category : 'tests' }
StFinderSaveCodeTest >> testCodeEditionInFinderShouldBeSavedWisely [

	self openInstance.
	self setExactAndCaseInsensitive.
	self doSearch: 'aBCSelectorSearchForRegexpStartWithCase'.

	"Precondition to know we are in the right state before the real test"
	self assert: presenter results size equals: 1.
	self
		assert: presenter previewSourcePresenter behavior
		equals: StFinderMockC.

	"Change the text, simulate cmd/ctrl s"
	presenter previewSourcePresenter text: 'toto "source"'.
	presenter previewSourcePresenter triggerSubmitAction.

	self
		assert: (StFinderMockC >> #toto) sourceCode
		equals: 'toto "source"'.

	self
		assert: (StFinderMockC >> #toto) protocol
		equals:
		(StFinderMockC >> #aBCSelectorSearchForRegexpStartWithCase) protocol
]

{ #category : 'tests' }
StFinderSaveCodeTest >> testFinderShouldModifyExistingMethod [

	| existingProtocol |
	self openInstance.
	self setExactAndCaseInsensitive.
	self doSearch: 'aBCSelectorSearchForRegexpStartWithCase'.

	"Precondition to know we are in the right state before the real test"
	self assert: presenter results size equals: 1.
	existingProtocol := presenter previewSourcePresenter interactionModel
		                    method protocol.
	self
		assert: presenter previewSourcePresenter behavior
		equals: StFinderMockC.

	"Change the text, simulate cmd/ctrl s"
	presenter previewSourcePresenter text:
		'aBCSelectorSearchForRegexpStartWithCase "source"'.
	presenter previewSourcePresenter triggerSubmitAction.

	self
		assert:
		(StFinderMockC >> #aBCSelectorSearchForRegexpStartWithCase)
			sourceCode
		equals: 'aBCSelectorSearchForRegexpStartWithCase "source"'.

	self
		assert:
		(StFinderMockC >> #aBCSelectorSearchForRegexpStartWithCase) protocol
		equals: existingProtocol
]

{ #category : 'tests' }
StFinderSaveCodeTest >> testFinderShouldNotTryToSaveWhenNoMethodSelected [
 
	"When trying to save when no method was selected, there was MessageNotUnderstood exception"
	self shouldnt: [ presenter previewSourcePresenter triggerSubmitAction ] raise: Error
]

{ #category : 'tests' }
StFinderSaveCodeTest >> testNewMethodCreation [

	self openInstance.
	self setExactAndCaseInsensitive.
	self doSearch: 'aBCSelectorSearchForRegexpStartWithCase'.

	"Precondition to know we are in the right state before the real test"
	self assert: presenter results size equals: 1.
	self
		assert: presenter previewSourcePresenter behavior
		equals: StFinderMockC.

	"Change the text, simulate cmd/ctrl s"
	presenter previewSourcePresenter text: 'toto "source"'.
	presenter previewSourcePresenter triggerSubmitAction.

	self
		assert: (StFinderMockC >> #toto) sourceCode
		equals: 'toto "source"'.

	self
		assert: (StFinderMockC >> #toto) protocol
		equals:
		(StFinderMockC >> #aBCSelectorSearchForRegexpStartWithCase) protocol
]

{ #category : 'tests' }
StFinderSaveCodeTest >> testSearchMethodThenClassAndSubmitTextOnClassDoesNothing [

	self openInstance.

	"First find a method. This will set the wrong callback"
	presenterModel currentSearch: StFinderSelectorSearch new.
	self doSearch: 'aBCSelectorSearchForRegexpStartWithCase'.

	"Now search the class. This should change the callback"
	presenterModel currentSearch: StFinderClassSearch new.
	self doSearch: 'mockC'.

	"We find the class and metaclass"
	self assert: presenter results size equals: 2.

	"Change the text, simulate cmd/ctrl s"
	presenter previewSourcePresenter text:
		'aBCSelectorSearchForRegexpStartWithCase "source"'.

	"This should to nothing. Smoke test..."
	presenter previewSourcePresenter triggerSubmitAction
]

{ #category : 'tests' }
StFinderSaveCodeTest >> testSubmitTextOnClassDoesNothing [

	self openInstance.
	presenterModel currentSearch: StFinderClassSearch new.
	self doSearch: 'mockC'.

	"We find the class and metaclass"
	self assert: presenter results size equals: 2.

	"Change the text, simulate cmd/ctrl s"
	presenter previewSourcePresenter text:
		'aBCSelectorSearchForRegexpStartWithCase "source"'.

	"This should to nothing. Smoke test..."
	presenter previewSourcePresenter triggerSubmitAction
]
