"
This presenter wraps those setting items which should present two drop lists. For instance, the case of syntax highlighting settings, where one could chose a `Color` and a text style (bold, normal, etc).


"
Class {
	#name : 'StSettingStyleElementPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#instVars : [
		'colorPresenter',
		'emphasisPresenter'
	],
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingStyleElementPresenterItem >> initializePresenters [ 
	| modelValue |

	modelValue := self model realValue.
	modelValue color
		ifNil: [ modelValue color: Color transparent ].

	colorPresenter := self newButton
		action: [ self pickColor ].
	emphasisPresenter := self newDropList 
		items: #(#bold #italic #normal 'bold italic' );
		selectItem: modelValue emphasis;		
		yourself.
	
	setterPresenter := self newPresenter.
	setterPresenter layout: (SpBoxLayout newLeftToRight 
		add: colorPresenter expand: false;
		add: emphasisPresenter;
		yourself).

	super initializePresenters
]

{ #category : 'initialization' }
StSettingStyleElementPresenterItem >> pickColor [
	| colorPickerPresenter |

	colorPickerPresenter := setterPresenter instantiate: SpColorPickerPresenter on: self model.
	(colorPickerPresenter asModalWindow
		owner: setterPresenter window;
		open) 
		isOk 
		ifFalse: [ ^ self ].

	self model realValue color: colorPickerPresenter color.
	self updateColor: colorPickerPresenter color
]

{ #category : 'accessing' }
StSettingStyleElementPresenterItem >> settingStyle [

	^ 'itemStyleElement'
]

{ #category : 'accessing' }
StSettingStyleElementPresenterItem >> updateColor: aColor [

	colorPresenter icon: aColor asSettingColorForm
]

{ #category : 'accessing' }
StSettingStyleElementPresenterItem >> value: aStyleElement [ 

	self updateColor: aStyleElement color.
	emphasisPresenter selectItem: aStyleElement emphasis

]
