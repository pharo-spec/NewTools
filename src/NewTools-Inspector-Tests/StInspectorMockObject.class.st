Class {
	#name : 'StInspectorMockObject',
	#superclass : 'Object',
	#category : 'NewTools-Inspector-Tests',
	#package : 'NewTools-Inspector-Tests'
}

{ #category : 'inspector extensions' }
StInspectorMockObject >> inspectionMock1 [
	<inspectorPresentationOrder: 0 title: 'Mock 1'>

	^ SpLabelPresenter new
		label: 'Test';
		yourself
]

{ #category : 'inspector extensions' }
StInspectorMockObject >> methodWithDnuingContext [
	<inspectorPresentationOrder: 0 title: 'PresentationWithDNUingContext'>

	^ SpLabelPresenter new
		label: 'Test';
		yourself
]

{ #category : 'inspector extensions' }
StInspectorMockObject >> methodWithDnuingContextContext: aContext [
	
	"This selector is automatically called by concatenating Context: to an inspector presentation"
	<ignoreNotImplementedSelectors: #(iShouldNotUnderstandThis)>
	self iShouldNotUnderstandThis
]

{ #category : 'inspector extensions' }
StInspectorMockObject >> methodWithDnuingPresentation [
	<inspectorPresentationOrder: 0 title: 'PresentationWithDNUingContext'>
	<ignoreNotImplementedSelectors: #(iShouldNotUnderstandThis)>
	self iShouldNotUnderstandThis
]

{ #category : 'inspector extensions' }
StInspectorMockObject >> methodWithFailingContext [
	<inspectorPresentationOrder: 0 title: 'PresentationWithFailingContext'>

	^ SpLabelPresenter new
		label: 'Test';
		yourself
]

{ #category : 'inspector extensions' }
StInspectorMockObject >> methodWithFailingContextContext: aContext [
	
	"This selector is automatically called by concatenating Context: to an inspector presentation"
	
	self error
]

{ #category : 'inspector extensions' }
StInspectorMockObject >> methodWithFailingPresentation [
	<inspectorPresentationOrder: 0 title: 'PresentationWithFailingPresentation'>

	self error
]

{ #category : 'inspector extensions' }
StInspectorMockObject >> methodWithHaltingContext [
	<inspectorPresentationOrder: 0 title: 'PresentationWithHaltingContext'>

	^ SpLabelPresenter new
		label: 'Test';
		yourself
]

{ #category : 'inspector extensions' }
StInspectorMockObject >> methodWithHaltingContextContext: aContext [
	
	"This selector is automatically called by concatenating Context: to an inspector presentation"
	<haltOrBreakpointForTesting>
	
	self halt
]

{ #category : 'inspector extensions' }
StInspectorMockObject >> methodWithHaltingPresentation [
	<inspectorPresentationOrder: 0 title: 'PresentationWithHaltingContext'>
	<haltOrBreakpointForTesting>
	
	self halt
]
