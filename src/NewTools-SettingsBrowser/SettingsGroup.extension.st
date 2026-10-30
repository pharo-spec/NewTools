Extension { #name : 'SettingsGroup' }

{ #category : '*NewTools-SettingsBrowser' }
SettingsGroup >> asSettingPresenterWithOwner: aPresenter [
	"Answer an appropriate <SpPresenter> container for the receiver's value"

	^ self isActivable
		  ifTrue: [ self realValue asSettingPresenter: self owner: aPresenter ]
		  ifFalse: [
				  aPresenter newLabel
					  addStyle: 'settingLabel';
					  label: self label;
					  yourself ]
]
