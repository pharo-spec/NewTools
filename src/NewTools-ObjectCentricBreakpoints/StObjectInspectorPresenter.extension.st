Extension { #name : 'StObjectInspectorPresenter' }

{ #category : '*NewTools-ObjectCentricBreakpoints' }
StObjectInspectorPresenter >> haltInspectedObjectOnStateAccess [
	^ self inspectedObject haltOnAccess 
]

{ #category : '*NewTools-ObjectCentricBreakpoints' }
StObjectInspectorPresenter >> haltInspectedObjectOnWriteAccess [
	^ self inspectedObject haltOnWrite
]
