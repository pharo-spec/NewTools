"
I am the root element in the world menu
"
Class {
	#name : 'StWorldMenuBuilderRoot',
	#superclass : 'StWorldMenuBuilderItem',
	#category : 'NewTools-WorldMenu-Model',
	#package : 'NewTools-WorldMenu',
	#tag : 'Model'
}

{ #category : 'visiting' }
StWorldMenuBuilderRoot >> acceptVisitor: aVisitor [

	^ aVisitor visitRoot: self
]
