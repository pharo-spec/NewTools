"
I am an adapter for tallies from TimeProfiler
"
Class {
	#name : 'StTallyModelTime',
	#superclass : 'StTallyModel',
	#category : 'NewTools-ProfilerUI-Model',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Model'
}

{ #category : 'accessing' }
StTallyModelTime >> methodClassName [

	^ item method methodClass name
]

{ #category : 'accessing' }
StTallyModelTime >> methodSelector [

	^ item method selector asString
]
