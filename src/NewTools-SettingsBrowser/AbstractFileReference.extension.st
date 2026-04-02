Extension { #name : 'AbstractFileReference' }

{ #category : '*NewTools-SettingsBrowser' }
AbstractFileReference >> asSettingPresenter: aSettingDeclaration owner: aPresenter [
	| settingPresenterClass |
	
	settingPresenterClass := self isDirectory 
		ifTrue: [ StSettingDirectoryPresenterItem ]
		ifFalse: [ StSettingFilePresenterItem ].
	^ (aPresenter instantiate: settingPresenterClass on: aSettingDeclaration)
		value: self;
		yourself
]

{ #category : '*NewTools-SettingsBrowser' }
AbstractFileReference >> asText [

	^ self fullName
]
