Extension { #name : 'ActionSettingDeclaration' }

{ #category : '*NewTools-SettingsBrowser' }
ActionSettingDeclaration >> asSettingPresenter [
	"Answer an appropriate <SpPresenter> for the receiver"

	^ StSettingButtonPresenterItem on: self

]
