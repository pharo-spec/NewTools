Extension { #name : 'TimeProfiler' }

{ #category : '*NewTools-ProfilerUI' }
TimeProfiler >> report [

	^ self fullReport
]

{ #category : '*NewTools-ProfilerUI' }
TimeProfiler >> startProfiling [
	"Created for compatibility with Andreas Profiler"
]

{ #category : '*NewTools-ProfilerUI' }
TimeProfiler >> stopProfiling [
	"Created for compatibility with AndreasProfiler"
]

{ #category : '*NewTools-ProfilerUI' }
TimeProfiler >> tallyRoot [
	^ rootMessageTally
]

{ #category : '*NewTools-ProfilerUI' }
TimeProfiler >> totalTime [
	^ rootMessageTally
		ifNotNil: [rootMessageTally time]
		ifNil: [ self error: 'profiler has not yet been run' ]
]
