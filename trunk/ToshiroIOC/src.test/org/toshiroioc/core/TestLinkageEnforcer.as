package org.toshiroioc.core
{
	
	import org.toshiroioc.plugins.puremvc.multicore.CommandMap;
	import org.toshiroioc.plugins.puremvc.multicore.SetterMap;
	import org.toshiroioc.test.puremvc.command.DynamicMacroOnLoadCommand;
	import org.toshiroioc.test.puremvc.command.DynamicPrepModelCommand;
	import org.toshiroioc.test.puremvc.command.DynamicPrepViewCommand;
	import org.toshiroioc.test.puremvc.command.DynamicSimpleStartupCommand;
	import org.toshiroioc.test.puremvc.command.MacroStartupCommand;
	import org.toshiroioc.test.puremvc.command.PrepModelCommand;
	import org.toshiroioc.test.puremvc.command.PrepViewCommand;
	import org.toshiroioc.test.puremvc.command.SimpleStartupCommand;
	import org.toshiroioc.test.puremvc.mediator.ExampleViewMediator;
	import org.toshiroioc.test.puremvc.mediator.ToshiroApplicationFacadeTestMediator;
	import org.toshiroioc.test.puremvc.model.DynamicExampleProxy;
	import org.toshiroioc.test.puremvc.model.DynamicExampleProxy2;
	import org.toshiroioc.test.puremvc.model.ExampleProxy;
  /**
   * Author: Damir Murat
   * Version: $Revision: 436 $, $Date: 2008-03-27 13:18:27 +0100 (do, 27 mrt 2008) $, $Author: dmurat1 $
   * Since: 0.4
   */
  public class TestLinkageEnforcer {
    // Here must be listed all classes that are used in the IoC configuration and are not mentioned anywhere in the
    // source. This is needed so that a compiler links them in a produced swf. Of course, final implementation should
    // be based on compiler settings, but this is quick workaround.
    private var linkageEnforcer:Object = {
   		prop1:PrepModelCommand,
    	prop2:PrepViewCommand,
      	prop3:MacroStartupCommand,
	   	prop4:ExampleViewMediator,
	    prop5:ToshiroApplicationFacadeTestMediator,
	    prop6:ExampleProxy,
	    prop7:SetterMap,
	    prop8:CommandMap,
	    simpleStartupCommand: SimpleStartupCommand,
		dynamicMacroCommand:DynamicMacroOnLoadCommand,
		dynamicPrepViewCommand:DynamicPrepViewCommand,
		dynamicPrepModelCommand : DynamicPrepModelCommand,
		dynamicExampleProxy : DynamicExampleProxy,
		dynamicExampleProxy2 : DynamicExampleProxy2,
		dynamicSimpleStartupCommand : DynamicSimpleStartupCommand
      
      
      
      
      
    };

    public function TestLinkageEnforcer() {
      super();
    }
  }
}
