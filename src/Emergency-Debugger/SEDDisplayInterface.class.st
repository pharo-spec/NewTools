Class {
	#name : #SEDDisplayInterface,
	#superclass : #Object,
	#instVars : [
		'frame'
	],
	#category : #'Emergency-Debugger'
}

{ #category : #'display - properties' }
SEDDisplayInterface >> black [
	^ Color black
]

{ #category : #'display - API' }
SEDDisplayInterface >> clear [
	self displayCanvas
		frameAndFillRectangle: self frame
		fillColor: self white
		borderWidth: 2
		borderColor: self red
]

{ #category : #'text - private' }
SEDDisplayInterface >> composeParagraphWith: aText inFrame: aRect [
	| paragraph |
	paragraph := Paragraph new.
	paragraph
		compose: aText
		style: self textStyle
		from: 1
		in: ((aRect insetBy: 4) withHeight: aRect height).
	^ paragraph
]

{ #category : #'display - private' }
SEDDisplayInterface >> display: aParagraph in: aRect [
	self displayCanvas
		paragraph: aParagraph
		bounds: aRect
		color: self black
]

{ #category : #'display - properties' }
SEDDisplayInterface >> displayCanvas [
	^Display getCanvas
]

{ #category : #'display - properties' }
SEDDisplayInterface >> frame [
	^ frame
		ifNil: [ frame := 0 @ 0 corner: DisplayScreen actualScreenSize * (0.3 @ 1) ]
]

{ #category : #'display - properties' }
SEDDisplayInterface >> red [
	^ Color red
]

{ #category : #'display - API' }
SEDDisplayInterface >> show: aText [
	self
		display: (self composeParagraphWith: aText inFrame: self frame)
		in: self frame
]

{ #category : #'text - private' }
SEDDisplayInterface >> textStyle [
	^ TextStyle default
]

{ #category : #'display - properties' }
SEDDisplayInterface >> white [
	^ Color white
]
