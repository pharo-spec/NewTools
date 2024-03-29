Extension { #name : 'StMetaBrowserPresenter' }

{ #category : '*NewTools-ObjectCentricBreakpoints' }
StMetaBrowserPresenter >> haltInspectedObjectOnCallToSelectedMethod [
	|method|
	method := self selectedMethod ifNil:[^self].
	self model haltOnCallTo: method selector
]

{ #category : '*NewTools-ObjectCentricBreakpoints' }
StMetaBrowserPresenter >> haltOnceInspectedObjectOnCallToSelectedMethod [
	|method|
	method := self selectedMethod ifNil:[^self].
	self model haltOnceOnCallTo: method selector
]

{ #category : '*NewTools-ObjectCentricBreakpoints' }
StMetaBrowserPresenter class >> objectCentricBreakpointCommandsWith: presenter forRootGroup: aRootCmCommandsGroup [
	<extensionCommands>
	
	(aRootCmCommandsGroup / 'methods')
		register: StHaltOnCallCommand forSpec;
		register: StHaltOnceOnCallCommand forSpec
]
