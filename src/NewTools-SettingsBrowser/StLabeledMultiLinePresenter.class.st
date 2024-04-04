Class {
	#name : 'StLabeledMultiLinePresenter',
	#superclass : 'SpLabeledPresenter',
	#classTraits : '{} + TraitedClass',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'layout' }
StLabeledMultiLinePresenter >> defaultLayout [
	^ SpBoxLayout newLeftToRight
		add: labelPresenter withConstraints: [ :constraints | constraints width: self labelWidth ];
		add:
			(SpBoxLayout newTopToBottom
				add: input withConstraints: [ :constraints | 
					constraints 
						width: self inputTextWidth;
						height: self inputTextHeight ];
				add: descriptionPresenter withConstraints: [ :constraints | 
					constraints 
						height: self inputTextHeight * 2.5 ]) width: self settingBoxWidth;
		yourself
]

{ #category : 'accessing' }
StLabeledMultiLinePresenter >> description: aString [
	aString ifNil: [ ^ self ].
	
	descriptionPresenter := self newText
		beWrapWord;
		text: aString;
		withoutEditionContextMenu;
		withoutScrollBars;
		addStyle: 'descriptionStyle';
		yourself
]

{ #category : 'layout' }
StLabeledMultiLinePresenter >> inputTextHeight [

	^ self class inputTextHeight
]

{ #category : 'layout' }
StLabeledMultiLinePresenter >> inputTextWidth [

	^ 400
]

{ #category : 'accessing' }
StLabeledMultiLinePresenter >> label: aString [

	super label: aString.
	labelPresenter help: aString.
]

{ #category : 'layout' }
StLabeledMultiLinePresenter >> labelWidth [

	^ self class labelWidth + 200
]

{ #category : 'layout' }
StLabeledMultiLinePresenter >> settingBoxWidth [

	^ 600
]
