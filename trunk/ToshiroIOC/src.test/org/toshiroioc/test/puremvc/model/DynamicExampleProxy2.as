package org.toshiroioc.test.puremvc.model
{
	
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class DynamicExampleProxy2 extends Proxy implements IProxy
	{
		public static const NAME:String = 'DynamicExampleProxy2';
		public static const DYNAMIC_PROXY_2_ON_REGISTER:String = 'dynamicExampleProxy2OnRegister';
		
		public function DynamicExampleProxy2()
		{
			super( NAME);
		}
		
		override public function onRegister():void
		{			
			sendNotification(DYNAMIC_PROXY_2_ON_REGISTER);
		}
	}
}
