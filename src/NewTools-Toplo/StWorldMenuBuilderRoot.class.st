Class {
	#name : 'StWorldMenuBuilderRoot',
	#superclass : 'StWorldMenuBuilderItem',
	#category : 'NewTools-Toplo-Backend',
	#package : 'NewTools-Toplo',
	#tag : 'Backend'
}

{ #category : 'visiting' }
StWorldMenuBuilderRoot >> acceptVisitor: aVisitor [

	^ aVisitor visitRoot: self
]
