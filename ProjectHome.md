### Overview ###

This is a bindings compatible switch. It's resolution independant and makes use of CoreAnimation.

![http://33software.com/images/components/SwitchControl.jpg](http://33software.com/images/components/SwitchControl.jpg)

SwitchControl exposes one binding:

  * NSValueBinding; a BOOL wrapped in an NSNumber

### Dependencies ###

  * Mac OS X Leopard 10.5
  * Objective-C 2.0

SwitchControl is dependent on a framework (AmberKitAdditions) contained inside another one of my projects Amber found at http://code.google.com/p/amber-framework which must be available at compile time.

### Using the Control ###

The easiest way to use SwitchControl is to instead [download Amber.framework](http://code.google.com/p/amber-framework/downloads/list) which contains all my custom UI controls and the AppKit additions required to use them.

Otherwise you can download the code for this project alone using an svn:external property to pull the 'code' subdirectory, i.e. http://switchcontrol.googlecode.com/svn/trunk/application/code, you could also pull the 'code' directory from a branch or tag.

### Building the Control ###

If you checkout the entire project and are building it from source then the Xcode project must be able to find the Amber Xcode project.

It expects to find the Amber working copy at the same level as it's own working directory. It must also be able to link the framework; the two projects should either share their build products directory, or you must set custom header search paths. See here http://lists.apple.com/archives/Xcode-users/2008/Sep/msg00268.html for more information.

Updated: 19/02/2009