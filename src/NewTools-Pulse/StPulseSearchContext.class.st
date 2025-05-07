Class {
	#name : 'StPulseSearchContext',
	#superclass : 'Object',
	#instVars : [
		'spotter',
		'browser'
	],
	#category : 'NewTools-Pulse',
	#package : 'NewTools-Pulse'
}

{ #category : 'accessing' }
StPulseSearchContext class >> searchEditors [

	^ StPulseSearchWindowsContext new
]

{ #category : 'private' }
StPulseSearchContext class >> searchEnvironment [

	^ StPulseSearchEnvironmentContext new
]

{ #category : 'as yet unclassified' }
StPulseSearchContext class >> searchTools [

	^ StPulseSearchToolsContext new
]

{ #category : 'visiting' }
StPulseSearchContext >> accept: aVisitor [

	self subclassResponsibility
]

{ #category : 'accessing' }
StPulseSearchContext >> associatedProcessors [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
StPulseSearchContext >> browser [

	^ browser
]

{ #category : 'accessing' }
StPulseSearchContext >> browser: aDockBrowser [

	browser := aDockBrowser
]

{ #category : 'accessing' }
StPulseSearchContext >> searchPlaceholder [

	^ self subclassResponsibility
]
