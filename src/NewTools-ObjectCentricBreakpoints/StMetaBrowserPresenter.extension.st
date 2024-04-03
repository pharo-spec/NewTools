Extension { #name : 'StMetaBrowserPresenter' }

{ #category : '*NewTools-ObjectCentricBreakpoints' }
StMetaBrowserPresenter >> haltOnceInspectedObjectOnCallToSelectedMethod [
	|method|
	method := self selectedMethod ifNil:[^self].
	self model haltOnceOnCallTo: method selector
]
