Class {
	#name : 'StPulseSearchEditorsContext',
	#superclass : 'StPulseSearchContext',
	#category : 'NewTools-Pulse',
	#package : 'NewTools-Pulse'
}

{ #category : 'accessing' }
StPulseSearchEditorsContext >> associatedProcessors [

	^ { StWindowsProcessor }
]

{ #category : 'accessing' }
StPulseSearchEditorsContext >> searchPlaceholder [

	^ 'Search for open windows...'
]
