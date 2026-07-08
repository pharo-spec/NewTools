Extension { #name : 'ActionSettingDeclaration' }

{ #category : '*NewTools-SettingsBrowser' }
ActionSettingDeclaration >> asSettingPresenterWithOwner: aPresenter [
	"Answer an appropriate <SpPresenter> for the receiver"

	^ aPresenter instantiate: StSettingButtonPresenterItem on: self

]
