Extension { #name : 'AndreasSystemProfiler' }

{ #category : '*NewTools-ProfilerUI' }
AndreasSystemProfiler >> runBlock: aBlock [
	"Compatibility with TimeProfiler"

	^ aBlock value
]

{ #category : '*NewTools-ProfilerUI' }
AndreasSystemProfiler >> tallyRoot [
	^ tallyRoot
]

{ #category : '*NewTools-ProfilerUI' }
AndreasSystemProfiler >> totalTally [
	^ totalTally
]

{ #category : '*NewTools-ProfilerUI' }
AndreasSystemProfiler >> totalTime [
	^ totalTime
]
