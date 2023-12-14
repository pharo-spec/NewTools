Extension { #name : 'QSystemTally' }

{ #category : '*NewTools-ProfilerUI' }
QSystemTally >> <= aQSystemTally [
	^ tally <= aQSystemTally tally
]

{ #category : '*NewTools-ProfilerUI' }
QSystemTally >> asTallyModel [
	^ StTallyModelAndreas new
		item: self;
		yourself
]

{ #category : '*NewTools-ProfilerUI' }
QSystemTally >> methodClassName [
	^ class ifNil: [ 'nil' ] ifNotNil: [ class name ]
]

{ #category : '*NewTools-ProfilerUI' }
QSystemTally >> methodOrBlock [
	^ method
]

{ #category : '*NewTools-ProfilerUI' }
QSystemTally >> originMethod [
	| methodOrBlock |
	methodOrBlock := self methodOrBlock.
	^ methodOrBlock isCompiledBlock
		  ifTrue: [ methodOrBlock method ]
		  ifFalse: [ methodOrBlock ]
]
