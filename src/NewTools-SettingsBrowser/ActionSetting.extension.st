Extension { #name : 'ActionSetting' }

{ #category : '*NewTools-SettingsBrowser' }
ActionSetting >> asSettingPresenterWithOwner: aPresenter [
	"Answer an appropriate <SpPresenter> for the receiver, shown on the settings page aPresenter"

	^ (aPresenter instantiate: StSettingButtonPresenterItem on: self)
		  pagePresenter: aPresenter;
		  yourself
]
