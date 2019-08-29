"
I am a configuration for Pharo IDE for Gtk backend. 
I will install a ""dark"" version of the UI theme, according to the platform version.
"
Class {
	#name : #StPharoGtkDarkConfiguration,
	#superclass : #StPharoGtkConfiguration,
	#category : #'NewTools-Gtk'
}

{ #category : #accessing }
StPharoGtkDarkConfiguration >> macThemeName [
		
	^ 'Sierra-dark'
]

{ #category : #accessing }
StPharoGtkDarkConfiguration >> unixThemeName [

	^ 'Adwaita-dark'
]

{ #category : #accessing }
StPharoGtkDarkConfiguration >> windowsThemeName [

	^ 'Windows-10-Dark-master'
]
