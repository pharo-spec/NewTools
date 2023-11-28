"
A trivial layout configurator for the `StDebugger`. 
It is configureable through api methods.
To change the layout, it takes as input a dictionary with the name of the element to layout associated to the element itself.
"
Class {
	#name : 'StDebuggerLayoutConfiguration',
	#superclass : 'Object',
	#instVars : [
		'order',
		'selectedLayout'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'configuration' }
StDebuggerLayoutConfiguration >> beHorizontalCodeThenStack [

	order := #( #code #stack ).
	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 30 percent;
		  yourself
]

{ #category : 'configuration' }
StDebuggerLayoutConfiguration >> beHorizontalStackThenCode [

	order := #( #stack #code ).
	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 30 percent;
		  yourself
]

{ #category : 'configuration' }
StDebuggerLayoutConfiguration >> beVerticalCodeThenStack [

	order := #( #code #stack ).
	^ SpPanedLayout newTopToBottom
		  positionOfSlider: 30 percent;
		  yourself
]

{ #category : 'configuration' }
StDebuggerLayoutConfiguration >> beVerticalStackThenCode [

	order := #( #stack #code ).
	^ SpPanedLayout newTopToBottom
		  positionOfSlider: 30 percent;
		  yourself
]

{ #category : 'configuration' }
StDebuggerLayoutConfiguration >> configureForLayouts: layoutsDictionary [

	| layout |
	layout := self perform: selectedLayout.

	order do: [ :layoutSymbol |
		layoutsDictionary at: layoutSymbol ifPresent: [ :l | layout add: l ] ].

	^ layout
]

{ #category : 'initialization' }
StDebuggerLayoutConfiguration >> initialize [

	order := #( #stack #code ).
	selectedLayout := #beVerticalStackThenCode
]

{ #category : 'accessing' }
StDebuggerLayoutConfiguration >> selectedLayout [

	^ selectedLayout
]

{ #category : 'accessing' }
StDebuggerLayoutConfiguration >> selectedLayout: anObject [

	selectedLayout := anObject
]
