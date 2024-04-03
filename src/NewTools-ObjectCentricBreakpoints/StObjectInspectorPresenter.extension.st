Extension { #name : 'StObjectInspectorPresenter' }

{ #category : '*NewTools-ObjectCentricBreakpoints' }
StObjectInspectorPresenter >> haltInspectedObjectOnStateAccess [
	^ self inspectedObject haltOnAccess 
]
