Extension { #name : 'StRawInspectionPresenter' }

{ #category : '*NewTools-ObjectCentricBreakpoints' }
StRawInspectionPresenter >> haltInspectedObjectOnAccess: access [
	| selectedItem |
	selectedItem := self selectedItem.
	selectedItem ifNil:[
		"No selection: halt on all accesses"
		^ self model haltOnAccess: access ].
	selectedItem key asSymbol == #self 
		ifTrue:[
			"Self is selected: halt on all accesses"
			^ self model haltOnAccess: access].
	^ self model haltOnAccess: access to: selectedItem key
]

{ #category : '*NewTools-ObjectCentricBreakpoints' }
StRawInspectionPresenter >> haltInspectedObjectOnStateAccess [
	^ self haltInspectedObjectOnAccess: #all
]
