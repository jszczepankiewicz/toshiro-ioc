### Introduction ###

Toshiro-IOC is ready to use in production. However there will be some features added in the future in order to make the project more complete and helpfull in real world applications. All of the future releases are planned to be interface compatible with the first released version (0.7)

### Features not planned ###

Toshiro-IOC is planned to be simple and lean container. It is not planned to make it 100% compatible with all of the Spring Framework IOC features. The autowire option is not planned to be implemented partially due to missing Actionscript reflection functionality. The second argument hides behaviour of the containers in big (real life) applications.

### Release plan ###

**0.7**
  * first release of the library (January 2010)

**0.8**
  * more ASDocs comments
  * refactored internal structure
  * support for some AS3 specific functionalities: using constants in setters / constructor arguments and some support for event listeners

**0.9**
  * added support to multifile implementation
  * added puremvc (multicore) support

**1.0**
  * added support for dynamically adding new xml files with object definitions, which will help to integrate the container into multicore applications (with dynamically added modules)