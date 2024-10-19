"
A command to show the refresh content option for inspectors.
"
Class {
	#name : 'StInspectorRefreshCommand',
	#superclass : 'StInspectorCommand',
	#category : 'NewTools-Inspector-Command',
	#package : 'NewTools-Inspector',
	#tag : 'Command'
}

{ #category : 'default' }
StInspectorRefreshCommand class >> defaultDescription [

	^ 'Refresh current panel'
]

{ #category : 'initialization' }
StInspectorRefreshCommand class >> defaultIconName [

	^ #refreshCircling
]

{ #category : 'default' }
StInspectorRefreshCommand class >> defaultName [
	<toolbarInspectCommand: 10>

	^ 'Refresh'
]

{ #category : 'documentation' }
StInspectorRefreshCommand class >> documentContextRequiredSelectors [

	^ super documentContextRequiredSelectors, #(refreshContent)
]

{ #category : 'execution' }
StInspectorRefreshCommand >> execute [ 

	self context refreshContent
]
