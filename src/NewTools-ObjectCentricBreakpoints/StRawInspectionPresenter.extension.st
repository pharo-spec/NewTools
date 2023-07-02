Extension { #name : #StRawInspectionPresenter }

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
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

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
StRawInspectionPresenter >> haltInspectedObjectOnReadAccess [
	^self haltInspectedObjectOnAccess: #read
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
StRawInspectionPresenter >> haltInspectedObjectOnStateAccess [
	^ self haltInspectedObjectOnAccess: #all
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
StRawInspectionPresenter >> haltInspectedObjectOnWriteAccess [
	^ self haltInspectedObjectOnAccess: #write
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
StRawInspectionPresenter class >> objectCentricBreakpointCommandsWith: presenter forRootGroup: aRootCmCommandsGroup [
	<extensionCommands>
	({StHaltOnReadCommand forSpec.
	StHaltOnWriteCommand forSpec.
	StHaltOnStateAccessCommand forSpec}
		select: [ :spCommand | spCommand decoratedCommand appliesTo: presenter ])
		do: [ :spCommand | aRootCmCommandsGroup register: spCommand ]
]
