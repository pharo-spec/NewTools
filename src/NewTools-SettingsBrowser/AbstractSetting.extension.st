Extension { #name : 'AbstractSetting' }

{ #category : '*NewTools-SettingsBrowser' }
AbstractSetting >> asPresenterOn: aPresenter [
	"Answer a <SpPresenter> for the receiver's setting type"

	^ self asSettingPresenterWithOwner: aPresenter
]

{ #category : '*NewTools-SettingsBrowser' }
AbstractSetting >> asSettingNode [
	
	^ StNewSettingNode forSetting: self
]

{ #category : '*NewTools-SettingsBrowser' }
AbstractSetting >> asSettingPresenterWithOwner: aPresenter [
	"Answer an appropriate <SpPresenter> container for the receiver's value"
	
	self subclassResponsibility
]
