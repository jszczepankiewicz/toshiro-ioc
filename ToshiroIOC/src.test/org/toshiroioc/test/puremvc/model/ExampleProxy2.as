package org.toshiroioc.test.puremvc.model
{
	
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class ExampleProxy2 extends Proxy implements IProxy
	{
		public static const NAME:String = 'ExampleProxy2';
		public static const EX_PROXY2_ON_REGISTER:String = 'exampleProxy2OnRegister';
		
		public function ExampleProxy2()
		{
			super( NAME);
		}
		
		override public function onRegister():void
		{			
			sendNotification(EX_PROXY2_ON_REGISTER, "5");
		}
	}
}