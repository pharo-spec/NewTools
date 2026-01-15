"
I represent a group in the world menu
"
Class {
	#name : 'StWorldMenuBuilderGroup',
	#superclass : 'StWorldMenuBuilderItem',
	#category : 'NewTools-WorldMenu-Model',
	#package : 'NewTools-WorldMenu',
	#tag : 'Model'
}

{ #category : 'visiting' }
StWorldMenuBuilderGroup >> acceptVisitor: aVisitor [

	^ aVisitor visitGroup: self
]
