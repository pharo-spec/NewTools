Extension { #name : 'Setting' }

{ #category : '*NewTools-SettingsBrowser' }
Setting >> asSettingPresenterWithOwner: aPresenter [
	"Answer an appropriate <SpPresenter> container for the receiver's value"

	^ self
		  ifPreconditionTrue: [ self realValue asSettingPresenter: self owner: aPresenter ]
		  ifFalse: [ SpNullPresenter owner: aPresenter ]
]

{ #category : '*NewTools-SettingsBrowser' }
Setting >> getColorFor: aPresenter [
	| colorPickerPresenter |

	colorPickerPresenter := aPresenter instantiate: SpColorPickerPresenter on: self.
	colorPickerPresenter
		whenColorChangedDo: [ :color |
				self realValue: color value.
				aPresenter updateColor: color value ];
		open
]
