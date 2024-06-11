"
I am an adapter for tallies from AndreasProfiler
"
Class {
	#name : 'StTallyModelAndreas',
	#superclass : 'StTallyModel',
	#category : 'NewTools-ProfilerUI-Model',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Model'
}

{ #category : 'accessing' }
StTallyModelAndreas >> childrenItems [

	^ super childrenItems reversed
]

{ #category : 'accessing' }
StTallyModelAndreas >> methodOrBlock [
	^ item methodOrBlock
]
