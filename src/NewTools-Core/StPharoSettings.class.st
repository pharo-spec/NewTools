Class {
	#name : #StPharoSettings,
	#superclass : #Object,
	#classVars : [
		'ToolbarDisplayMode'
	],
	#category : #'NewTools-Core-Application'
}

{ #category : #settings }
StPharoSettings class >> defaultToolbarDisplayMode [

	^ SpToolBarDisplayMode modeIconAndLabel
]

{ #category : #settings }
StPharoSettings class >> toolbarDisplayMode [

	^ ToolbarDisplayMode ifNil: [ ToolbarDisplayMode := self defaultToolbarDisplayMode ]
]

{ #category : #settings }
StPharoSettings class >> toolbarDisplayMode: aMode [
	"e.g. SpToolBarDisplayMode modeIcon"
	
	ToolbarDisplayMode := aMode
]
