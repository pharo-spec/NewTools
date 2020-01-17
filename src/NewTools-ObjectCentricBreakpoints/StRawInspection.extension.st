Extension { #name : #StRawInspection }

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
StRawInspection class >> objectCentricBreakpointCommandsWith: presenter forRootGroup: aRootCmCommandsGroup [
	<extensionCommands>
	aRootCmCommandsGroup
		register: OCHaltOnReadCommand forSpec;
		register: OCHaltOnWriteCommand forSpec;
		register: OCHaltOnStateAccessCommand forSpec
		
]
