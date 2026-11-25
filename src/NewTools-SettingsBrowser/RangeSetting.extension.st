Extension { #name : 'RangeSetting' }

{ #category : '*NewTools-SettingsBrowser' }
RangeSetting >> asSettingPresenterWithOwner: aPresenter [
	"Answer an appropriate <SpPresenter> container for the receiver's value"

	^ aPresenter instantiate: StSettingDropListPresenterItem on: self
]
