"
A trivial layout configurator for the `StDebugger`. 
It is configureable through api methods.
To change the layout, it takes as input a dictionary with the name of the element to layout associated to the element itself.
"
Class {
	#name : 'StDebuggerLayoutConfiguration',
	#superclass : 'Object',
	#instVars : [
		'layout',
		'order'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'configuration' }
StDebuggerLayoutConfiguration >> beHorizontalCodeThenStack [

	layout := SpPanedLayout newLeftToRight
		          positionOfSlider: 30 percent;
		          yourself.
	order := #( #code #stack )
]

{ #category : 'configuration' }
StDebuggerLayoutConfiguration >> beHorizontalStackThenCode [

	layout := SpPanedLayout newLeftToRight
		          positionOfSlider: 30 percent;
		          yourself.
	order := #( #stack #code )
]

{ #category : 'configuration' }
StDebuggerLayoutConfiguration >> beVerticalCodeThenStack [

	layout := SpPanedLayout newTopToBottom
		          positionOfSlider: 30 percent;
		          yourself.
	order := #( #code #stack )
]

{ #category : 'configuration' }
StDebuggerLayoutConfiguration >> beVerticalStackThenCode [

	layout := SpPanedLayout newTopToBottom 
		          positionOfSlider: 30 percent;
		          yourself.
	order := #( #stack #code )
]

{ #category : 'configuration' }
StDebuggerLayoutConfiguration >> configureForLayouts: layoutsDictionary [

	order do: [ :layoutSymbol |
		layoutsDictionary at: layoutSymbol ifPresent: [ :l | layout add: l ] ].

	^ layout
]

{ #category : 'initialization' }
StDebuggerLayoutConfiguration >> initialize [

	layout := SpPanedLayout newTopToBottom
		          positionOfSlider: 30 percent;
		          yourself.
	order := #( #stack #code )
]
