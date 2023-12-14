"
I am an adapter for tallies from AndreasProfiler
"
Class {
	#name : 'TallyModelAndreas',
	#superclass : 'TallyModel',
	#category : 'NewTools-ProfilerUI-Model',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Model'
}

{ #category : 'accessing' }
TallyModelAndreas >> childrenItems [

	^ super childrenItems reversed
]

{ #category : 'accessing' }
TallyModelAndreas >> methodOrBlock [
	^ item methodOrBlock
]
