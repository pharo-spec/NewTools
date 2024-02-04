Extension { #name : 'PragmaSetting' }

{ #category : '*NewTools-SettingsBrowser' }
PragmaSetting >> asSettingPresenter [
	"Answer an appropriate <SpPresenter> for the receiver"

	^ self label asPresenter
]
