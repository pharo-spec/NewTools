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
		'LastKnownPosition',
		'PreserveWindowPosition'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'accessing' }
StDebuggerSettings class >> defaultPosition [

	^ 10 @ 10

]

{ #category : 'class initialization' }
StDebuggerSettings class >> initialize [

	LastKnownPosition := self defaultPosition.
	
]

{ #category : 'initialization' }
StDebuggerSettings class >> initializeWindow: aWindowPresenter [
	"Set global window position and extent using window data in aStDebugger"
	"Pay attention this is not a presenter so the method name is misleading."
	
	self preserveWindowPosition ifFalse: [ ^ self ].
	aWindowPresenter whenClosedDo: [
		self
			lastKnownPosition: (aWindowPresenter window ifNotNil: [ : wnd | wnd position ]) ]
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
StDebuggerSettings class >> preserveWindowPosition [

	^ PreserveWindowPosition ifNil: [ PreserveWindowPosition := true ]
]

{ #category : 'accessing' }
StDebuggerSettings class >> preserveWindowPosition: aBoolean [

	PreserveWindowPosition := aBoolean
]

{ #category : 'initialization' }
StDebuggerSettings class >> preserveWindowPositionAndExtentOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #preserveWindowPosition)
		label: 'Preserve window position';
		target: self;
		parentName: #debugging;
		defaultValue: true;
		description:
			'If enabled, the debugger will preserve the last known window position, and it will open new debugger windows in that configuration'
]
