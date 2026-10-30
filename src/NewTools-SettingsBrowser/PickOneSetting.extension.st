Extension { #name : 'PickOneSetting' }

{ #category : '*NewTools-SettingsBrowser' }
PickOneSetting >> asSettingPresenterWithOwner: aPresenter [
	"Answer an appropriate <SpPresenter> container for the receiver's value"

	^ aPresenter instantiate: StSettingDropListPresenterItem on: self
]
