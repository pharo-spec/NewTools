"
I am an adapter for tallies from TimeProfiler
"
Class {
	#name : 'TallyModelTime',
	#superclass : 'TallyModel',
	#category : 'NewTools-ProfilerUI-Model',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Model'
}

{ #category : 'accessing' }
TallyModelTime >> methodClassName [

	^ item method methodClass name
]

{ #category : 'accessing' }
TallyModelTime >> methodSelector [

	^ item method selector asString
]
