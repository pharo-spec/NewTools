"
Abstract class which holds presenters composing a ""set item"".
At minimum, this class provides a label and an input presenter. Subclasses could adapt the `defaultLayout` method to add buttons or additional presenters. For instance, subclases provide a ""Directory"" presenter which also includes a button beside the input box, to open a Directory browser.

"
Class {
	#name : 'StLabeledSettingPresenter',
	#superclass : 'SpLabeledPresenter',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'layout' }
StLabeledSettingPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		add: labelPresenter withConstraints: [ :constraints | constraints width: self labelWidth ];
		add: (SpBoxLayout newTopToBottom
				add: input withConstraints: [ :constraints | 
					constraints height: self inputTextHeight ]);
		yourself
]

{ #category : 'accessing' }
StLabeledSettingPresenter >> description: aString [

	aString ifNil: [ ^ self ].
	labelPresenter help: aString.
	labelPresenter eventHandler 
		whenMouseEnterDo: [ : e | self owner help: labelPresenter help ].
	input eventHandler 
		whenMouseEnterDo: [ : e | self owner help: labelPresenter help ];
		whenFocusReceivedDo: [ : e | self owner help: labelPresenter help ].

]

{ #category : 'layout' }
StLabeledSettingPresenter >> inputTextHeight [

	^ self class inputTextHeight
]

{ #category : 'layout' }
StLabeledSettingPresenter >> labelWidth [

	^ self class labelWidth + 200
]
