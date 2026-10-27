Extension { #name : 'ActionSetting' }

{ #category : '*NewTools-SettingsBrowser' }
ActionSetting >> asSettingPresenterWithOwner: aPresenter [
	"Answer an appropriate <SpPresenter> for the receiver"

	^ aPresenter instantiate: StSettingButtonPresenterItem on: self
]
