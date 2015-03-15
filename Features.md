### Introduction ###

This page provides information about supported features by Toshiro-IOC container.

### Features ###
  * configuration by xml (utf-8 recommended)
  * object instantiation using both defined and non-def constructor
  * setter injection
  * constructor injection
  * support for primitive values (Number, int, uint, Boolean, String)
  * support for Date value (using [JAXB](https://jaxb.dev.java.net/) Date casting)
  * support for class values (injecting value that will be resolved from String full domain name into Class type)
  * support for direct null injection
  * support for both singletons (default lifecycle type of object) and prototypes
  * unit testing coverage for all of the features

### Error handling ###
Toshiro-IOC uses ContainerError object to inform about all the exceptions occured. Container has built-in error detection in the following areas:
  * **circular dependencies** detection
  * wrong types of objects
  * objects not found

For more information please read the full documentation about configuration by example.