Class {
	#name : 'StPulseSearchWindowsContext',
	#superclass : 'StPulseSearchContext',
	#category : 'NewTools-Pulse',
	#package : 'NewTools-Pulse'
}

{ #category : 'accessing' }
StPulseSearchWindowsContext >> associatedProcessors [

	^ { StWindowsProcessor }
]

{ #category : 'accessing' }
StPulseSearchWindowsContext >> searchPlaceholder [

	^ 'Search for open windows...'
]
