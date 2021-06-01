Class {
	#name : #StInspectorMockObject,
	#superclass : #Object,
	#category : #'NewTools-Inspector-Tests'
}

{ #category : #'inspector extensions' }
StInspectorMockObject >> inspectionMock1 [
	<inspectorPresentationOrder: 0 title: 'Mock 1'>

	^ SpLabelPresenter new
		label: 'Test';
		yourself
]
