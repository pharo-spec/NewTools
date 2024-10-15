Extension { #name : 'SystemSettingsPersistence' }

{ #category : '*NewTools-SettingsBrowser' }
SystemSettingsPersistence >> hasSettingsFile [
	"Answer <true> if the system settings file exists"

	^ fileReference exists
]
