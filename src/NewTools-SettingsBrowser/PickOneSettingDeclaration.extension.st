Extension { #name : 'PickOneSettingDeclaration' }

{ #category : '*NewTools-SettingsBrowser' }
PickOneSettingDeclaration >> asSettingPresenterWithOwner: aPresenter [
	"Answer an appropriate <SpPresenter> container for the receiver's value"

	^ aPresenter instantiate: StSettingDropListPresenterItem on: self

]
