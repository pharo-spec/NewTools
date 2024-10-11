"
A `StDebuggerSettings` class holds and manages global settings for the Pharo Debugger.

This class provides a centralized way to configure and access various debugger settings that affect the behavior and appearance of the Pharo Debugger across the system.

## Responsibility
- Store and provide access to global debugger settings
- Offer methods to modify these settings
- Ensure settings persistence across sessions

## Collaborators
- StDebugger: The main debugger class that uses these settings
- Settings Framework: For integration with Pharo's settings browser

## Examples
```
    StDebuggerSettings lastKnownPosition.
    StDebuggerSettings preserveWindowPosition.
```

## Internal Representation and Key Implementation Points:
- Uses class-side methods and class variables to store settings
- Integrates with Pharo's Settings framework for easy configuration through the Settings Browser

Note: This class is part of the core debugging infrastructure in Pharo and should be modified with caution.


"
Class {
	#name : 'StDebuggerSettings',
	#superclass : 'Object',
	#classVars : [
		'LastKnownExtent',
		'LastKnownPosition',
		'PreserveWindowPositionAndExtent'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'accessing' }
StDebuggerSettings class >> defaultExtent [

	^ (850 @ 650)

]

{ #category : 'accessing' }
StDebuggerSettings class >> defaultPosition [

	^ 10 @ 10

]

{ #category : 'class initialization' }
StDebuggerSettings class >> initialize [

	LastKnownPosition := self defaultPosition.
	LastKnownExtent := self defaultExtent.
]

{ #category : 'initialization' }
StDebuggerSettings class >> initializeWindow: aWindowPresenter [
	"Set global window position and extent using window data in aStDebugger"

	self preserveWindowPositionAndExtent ifFalse: [ ^ self ].
	aWindowPresenter whenClosedDo: [
		self
			lastKnownPosition: (aWindowPresenter window ifNotNil: [ : wnd | wnd position ]);
			lastKnownExtent: (aWindowPresenter window ifNotNil: [ : wnd | wnd extent ]) ]
]

{ #category : 'accessing' }
StDebuggerSettings class >> lastKnownExtent [
	"Answer a <Point> specifying the last window known extent in the screen"

	^ LastKnownExtent
		ifNil: [ LastKnownExtent := self defaultExtent ]
]

{ #category : 'accessing' }
StDebuggerSettings class >> lastKnownExtent: aPoint [
	"Set a <Point> as the last window known extent in the screen"

	LastKnownExtent := aPoint
]

{ #category : 'accessing' }
StDebuggerSettings class >> lastKnownPosition [
	"Answer a <Point> specifying the last window known position in the screen"

	^ LastKnownPosition
		ifNil: [ LastKnownPosition := self defaultPosition ]
]

{ #category : 'accessing' }
StDebuggerSettings class >> lastKnownPosition: aPoint [
	"Set a <Point> as the last window known position in the screen"

	LastKnownPosition := aPoint
]

{ #category : 'accessing' }
StDebuggerSettings class >> preserveWindowPositionAndExtent [

	^ PreserveWindowPositionAndExtent
		ifNil: [ PreserveWindowPositionAndExtent := true ]
]

{ #category : 'accessing' }
StDebuggerSettings class >> preserveWindowPositionAndExtent: aBoolean [

	PreserveWindowPositionAndExtent := aBoolean
]

{ #category : 'accessing' }
StDebuggerSettings class >> preserveWindowPositionAndExtentOn: aBuilder [
	<systemsettings>
	
	(aBuilder setting: #preserveWindowPositionAndExtent)
		label: 'Preserve window position and extent';
		target: self;
		parent: #debugging;
		default: true;
		description: 'If enabled, the debugger will preserve the last known window position and extent, and it will open new debugger windows in that configuration'.
]
