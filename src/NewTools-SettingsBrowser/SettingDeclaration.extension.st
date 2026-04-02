Extension { #name : 'SettingDeclaration' }

{ #category : '*NewTools-SettingsBrowser' }
SettingDeclaration >> asSettingPresenterWithOwner: aPresenter [
	"Answer an appropriate <SpPresenter> container for the receiver's value"

	^ self precondition value 
		ifTrue: [ 
			self hasValue
				ifTrue: [ self realValue asSettingPresenter: self owner: aPresenter ]
				ifFalse: [ self default asSettingPresenter: self owner: aPresenter ] ]
		ifFalse: [ SpNullPresenter owner: aPresenter ]
]

{ #category : '*NewTools-SettingsBrowser' }
SettingDeclaration >> getColorFor: aPresenter [

	| colorPickerPresenter |

	colorPickerPresenter := aPresenter instantiate: SpColorPickerPresenter on: self.
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
