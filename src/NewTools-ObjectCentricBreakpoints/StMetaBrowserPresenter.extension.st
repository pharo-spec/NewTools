Extension { #name : #StMetaBrowserPresenter }

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
StMetaBrowserPresenter >> haltInspectedObjectOnCallToSelectedMethod [
	|method|
	method := self selectedMethod ifNil:[^self].
	self model haltOnCallTo: method selector
]

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
StMetaBrowserPresenter class >> objectCentricBreakpointCommandsWith: presenter forRootGroup: aRootCmCommandsGroup [
	<extensionCommands>
	
	(aRootCmCommandsGroup / 'methods')
		register: StHaltOnCallCommand forSpec
]
