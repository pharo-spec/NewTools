Class {
	#name : 'StPulseSearchToolsContext',
	#superclass : 'StPulseSearchContext',
	#category : 'NewTools-Pulse',
	#package : 'NewTools-Pulse'
}

{ #category : 'accessing' }
StPulseSearchToolsContext >> associatedProcessors [

	^ { StWorldMenuProcessor }
]

{ #category : 'accessing' }
StPulseSearchToolsContext >> searchPlaceholder [

	^ 'Search for system tools...'
]
