Extension { #name : 'InformativeNotification' }

{ #category : '*NewTools-Utils' }
InformativeNotification >> defaultAction [
	"We want to inform the user if there is a missing source file."

	StPharoApplication current inform: self messageText
]
