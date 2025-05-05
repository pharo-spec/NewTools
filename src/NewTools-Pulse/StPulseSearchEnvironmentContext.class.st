Class {
	#name : 'StPulseSearchEnvironmentContext',
	#superclass : 'StPulseSearchContext',
	#category : 'NewTools-Pulse',
	#package : 'NewTools-Pulse'
}

{ #category : 'accessing' }
StPulseSearchEnvironmentContext >> associatedProcessors [

	^ { StUnifiedProcessor }
]

{ #category : 'accessing' }
StPulseSearchEnvironmentContext >> searchPlaceholder [

	^ 'Search for classes, methods, packages...'
]
