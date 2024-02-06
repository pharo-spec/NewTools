Extension { #name : 'PickOneSettingDeclaration' }

{ #category : '*NewTools-SettingsBrowser' }
PickOneSettingDeclaration >> asSettingPresenter [
	"Answer an appropriate <SpPresenter> container for the receiver's value"

	^ StSettingDropListPresenterItem on: self

]
