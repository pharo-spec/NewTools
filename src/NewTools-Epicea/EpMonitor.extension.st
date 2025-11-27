Extension { #name : 'EpMonitor' }

{ #category : '*NewTools-Epicea' }
EpMonitor >> statusIcon [
	^ self isEnabled
		ifTrue: [ #testGreen ]
		ifFalse: [ #testNotRun ]
]

{ #category : '*NewTools-Epicea' }
EpMonitor >> statusString [
	^ self isEnabled
		ifTrue: [ 'Monitor enabled' ]
		ifFalse: [ 'Monitor disabled' ]
]
