"
Provides a color picker with a toolbar to confirm or cancel the selected color.

"
Class {
	#name : 'SpColorPickerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'colorPickerPresenter',
		'toolbar',
		'colorChangedBlock'
	],
	#category : 'ColorPicker',
	#package : 'ColorPicker'
}

{ #category : 'accessing' }
SpColorPickerPresenter class >> defaultPreferredExtent [

	^ 350 @ 550
]

{ #category : 'instance creation' }
SpColorPickerPresenter class >> open [
	<script>

	^ (self newApplication: StPharoApplication current) open
]

{ #category : 'events' }
SpColorPickerPresenter >> colorChanged [

	colorChangedBlock ifNil: [ ^ self ].
	^ colorChangedBlock value: colorPickerPresenter color
]

{ #category : 'layout' }
SpColorPickerPresenter >> defaultLayout [ 
	
	^ SpBoxLayout newTopToBottom 
		add: colorPickerPresenter;
		yourself
]

{ #category : 'initialization' }
SpColorPickerPresenter >> initializePresenters [

	colorPickerPresenter := self newColorPicker.
	toolbar := self newToolbar.
	self toolbarButtons do: [ :button | toolbar addItemRight: button ]
]

{ #category : 'initialization' }
SpColorPickerPresenter >> toolbarButtons [
	| buttons |

	buttons := OrderedCollection new.
	buttons 
			add: (self newToolbarButton
			 label: 'Select';
			 icon: (self iconNamed: #smallOk);
			 help: 'Select and close';
			 action: [ self colorChanged. self delete ];
			 yourself);
			add: (self newToolbarButton
					 label: 'Cancel';
					 icon: (self iconNamed: #smallCancel);
					 help: 'Cancel the color selection';
					 action: [ self delete ];
					 yourself).

	^ buttons
]

{ #category : 'events' }
SpColorPickerPresenter >> whenColorChangedDo: aBlock [

	colorChangedBlock := aBlock
]

{ #category : 'initialization' }
SpColorPickerPresenter >> windowIcon [

	^ self iconNamed: #smallPaint
]

{ #category : 'initialization' }
SpColorPickerPresenter >> windowTitle [

	^ 'Color Picker'
]
