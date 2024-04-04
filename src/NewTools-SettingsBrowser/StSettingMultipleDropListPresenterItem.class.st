"
This presenter wraps those setting items which should present two drop lists. For instance, the case of syntax highlighting settings, where one could chose a `Color` and a text style (bold, normal, etc).


"
Class {
	#name : 'StSettingMultipleDropListPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#instVars : [
		'colorSettingItemPresenter'
	],
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingMultipleDropListPresenterItem >> initializePresenters [ 

	| modelDefault |

	modelDefault := self model default.
	modelDefault color
		ifNil: [ modelDefault color: Color transparent ].
	colorSettingItemPresenter := modelDefault color asSettingPresenter: model.

	setterPresenter := self newDropList 
		items: #(#bold #italic #normal 'bold italic' );
		selectItem: modelDefault emphasis;		
		yourself.
	super initializePresenters.
]

{ #category : 'accessing' }
StSettingMultipleDropListPresenterItem >> value: aSHStyleElement [ 

	self flag: #delete.
	colorSettingItemPresenter 
		buttonColor: aSHStyleElement color.
	setterPresenter selectItem: aSHStyleElement emphasis.

]
