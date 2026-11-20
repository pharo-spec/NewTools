"
I define a command to add a breakpoint on the AST node corresponding to the selected code and I open a debug point browser on the created breakpoint to configure it
"
Class {
	#name : 'ClyAddAndConfigureBreakPointCommand',
	#superclass : 'ClyDebuggingPointsCommand',
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'execution' }
ClyAddAndConfigureBreakPointCommand >> executeRefactoring [

	| dp |
	dp := DebugPointManager installNew: BreakDebugPoint on: self sourceNode.
	DebugPointBrowserPresenter openOn: dp
]

{ #category : 'accessing' }
ClyAddAndConfigureBreakPointCommand >> iconName [

	^ #smallConfiguration
]

{ #category : 'accessing' }
ClyAddAndConfigureBreakPointCommand >> name [

	^ String streamContents: [ :stream | stream << 'Configure Breakpoint on "' << self sourceNode displaySourceCode << '"' ]
]
