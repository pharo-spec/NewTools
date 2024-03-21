Extension { #name : 'StRawInspectionPresenter' }

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StRawInspectionPresenter >> breakInspectedObjectOnAccess [

	^ self breakInspectedObjectOnAccess: #all
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StRawInspectionPresenter >> breakInspectedObjectOnAccess: access [
	| selectedItem |
	selectedItem := self selectedItem.
	selectedItem ifNil:[
		"No selection: halt on all accesses"
		^ self model breakOnAccess: access ].
	selectedItem key asSymbol == #self 
		ifTrue:[
			"Self is selected: halt on all accesses"
			^ self model breakOnAccess: access].
	^ self model breakOnAccess: access toSlotNamed: selectedItem key
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StRawInspectionPresenter >> breakInspectedObjectOnRead [

	^ self breakInspectedObjectOnAccess: #read
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StRawInspectionPresenter >> breakInspectedObjectOnWrite [

	^ self breakInspectedObjectOnAccess: #write
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StRawInspectionPresenter class >> objectCentricDebugPointCommandsWith: presenter forRootGroup: aRootCmCommandsGroup [

	<extensionCommands>
	(StDebugPointSlotTargetCommand allSubclasses
		 collect: [ :aCommandClass | aCommandClass forSpec ]
		 thenSelect: [ :spCommand |
		 spCommand decoratedCommand appliesTo: presenter ]) do: [ :spCommand |
		aRootCmCommandsGroup register: spCommand ]
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StRawInspectionPresenter >> watchInspectedObjectAccess [

	^ self watchInspectedObjectOnAccess: #all
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StRawInspectionPresenter >> watchInspectedObjectOnAccess: access [
	| selectedItem |
	selectedItem := self selectedItem.
	selectedItem ifNil:[
		"No selection: halt on all accesses"
		^ self model watchOnAccess: access ].
	selectedItem key asSymbol == #self 
		ifTrue:[
			"Self is selected: halt on all accesses"
			^ self model watchOnAccess: access].
	^ self model watchOnAccess: access toSlotNamed: selectedItem key
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StRawInspectionPresenter >> watchInspectedObjectRead [

	^ self watchInspectedObjectOnAccess: #read
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StRawInspectionPresenter >> watchInspectedObjectWrite [

	^ self watchInspectedObjectOnAccess: #write
]
