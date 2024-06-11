Extension { #name : 'StMetaBrowserPresenter' }

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StMetaBrowserPresenter >> breakOnCallToSelectedMethod [

	| method |
	method := self selectedMethod ifNil: [ ^ self ].
	self model breakOnCallTo: method selector
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StMetaBrowserPresenter >> breakOnceOnCallToSelectedMethod [

	| method |
	method := self selectedMethod ifNil: [ ^ self ].
	self model breakOnceOnCallTo: method selector
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StMetaBrowserPresenter class >> objectCentricDebugPointCommandsWith: presenter forRootGroup: aRootCmCommandsGroup [

	<extensionCommands>
	| methodsCommandGroup |
	methodsCommandGroup := aRootCmCommandsGroup / 'methods'.
	StDebugPointNodeTargetCommand allSubclassesDo: [ :commandClass |
		methodsCommandGroup register: commandClass forSpec ]
]
