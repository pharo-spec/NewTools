"
I define a command to add a breakpoint on the AST node corresponding to the selected code and I open a debug point browser on the created breakpoint to configure it
"
Class {
	#name : 'ClyAddAndConfigureBreakPointCommand',
	#superclass : 'ClyDebuggingPointsCommand',
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'accessing' }
ClyAddAndConfigureBreakPointCommand >> defaultMenuIconName [

	^ #smallConfiguration
]

{ #category : 'accessing' }
ClyAddAndConfigureBreakPointCommand >> defaultMenuItemName [

	^ ' Add Breakpoint to: ' , sourceNode displaySourceCode
	  , 'and configure it'
]

{ #category : 'execution' }
ClyAddAndConfigureBreakPointCommand >> execute [

	| dp |
	dp := DebugPointManager installNew: BreakDebugPoint on: sourceNode.
	DebugPointBrowserPresenter openOn: dp
]
