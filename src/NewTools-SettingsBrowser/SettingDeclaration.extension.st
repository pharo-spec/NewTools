Extension { #name : 'SettingDeclaration' }

{ #category : '*NewTools-SettingsBrowser' }
SettingDeclaration >> asSettingPresenter [
	"Answer an appropriate <SpPresenter> container for the receiver's value"

	^ self precondition value 
		ifTrue: [ 
			self hasValue
				ifTrue: [ self realValue asSettingPresenter: self ]
				ifFalse: [ self default asSettingPresenter: self ] ]
		ifFalse: [ SpNullPresenter new ]
]

{ #category : '*NewTools-SettingsBrowser' }
SettingDeclaration >> getColorFor: aPresenter [

	| colorPickerPresenter |

	colorPickerPresenter := aPresenter instantiate: SpColorPickerWindow on: self.
	colorPickerPresenter
		whenChangedDo: [ : c | 
			| changedAspect |
			"First we need to get the setter selector, then apply it"
			"Some settings are built 'customized' configuring its setter in a different way than using #targetSelector (see #customSettingsOn:)"
			self targetSelector 
				ifNil: [ 
					self realTarget perform: self name asMutator with: c value.
					changedAspect := self realTarget ]
				ifNotNil: [ 
					changedAspect := self realTarget perform: self targetSelector.
					changedAspect perform: self setSelector with: c value. ].
			aPresenter updateColor: c value ];
		open
]
