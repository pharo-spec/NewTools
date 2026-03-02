Extension { #name : 'ConfirmationRequest' }

{ #category : '*NewTools-Core' }
ConfirmationRequest >> defaultAction [
	"We want the user to confirm some choices."

	^ StPharoApplication current confirm: self messageText
]
